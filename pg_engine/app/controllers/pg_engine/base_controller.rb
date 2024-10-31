# frozen_string_literal: true

module PgEngine
  # rubocop:disable Rails/ApplicationController
  # rubocop:disable Metrics/ClassLength
  class BaseController < ActionController::Base
    # Importante que esta línea esté al principio
    protect_from_forgery with: :exception

    set_current_tenant_by_subdomain_or_domain(:account, :subdomain, :domain)
    set_current_tenant_through_filter

    def default_url_options
      if Current.active_user_account
        { tenant_id: Current.active_user_account.to_param }
      else
        { tenant_id: nil }
      end
    end

    # rubocop:disable Metrics/BlockLength
    before_action do
      Current.user = current_user
      Current.controller = self

      # if ActsAsTenant.current_tenant.blank? && !global_domain?
      #   raise ActsAsTenant::Errors::NoTenantSet
      # end
      # FIXME: if current_tenant.present? check it's not discarded
      # FIXME: if session['ss_current_user_account_id'] present? check
      #        user belongs to it, and if not, cleanup
      if Current.user.present?
        active_user_accounts = Current.user.user_accounts.active.to_a
        if ActsAsTenant.current_tenant.present?
          # TODO: los controller tests pasan por acá porque no se ejecuta
          # el tenant middleware. cambiarlos a requests specs
          # TODO: testear
          unless active_user_accounts.any? { |uac| uac.account == ActsAsTenant.current_tenant }
            pg_warn <<~WARN
              #{Current.user.to_gid} not belongs to \
              #{ActsAsTenant.current_tenant.to_gid}. Signed out
            WARN

            sign_out(Current.user)
            throw :warden, scope: :user, message: :invalid
          end

          @current_tenant_set_by_domain_or_subdomain = true
        else
          ua = nil
          uaid = if params[:tenant_id].present?
                   UserAccount.decode_id(params[:tenant_id])
                   # elsif session['ss_current_user_account_id'].present?
                   #   session['ss_current_user_account_id']
                 end

          if uaid.present?
            ua = active_user_accounts.find { |uac| uac.id == uaid }
          end

          # account = if params[:tenant_id].present?
          #             begin
          #               ua = UserAccount.find(params[:tenant_id])
          #               session['ss_current_user_account_id'] = ua.id
          #               ua.account
          #             rescue ActiveRecord::RecordNotFound => e
          #               pg_warn(e)
          #             end
          #           elsif session['ss_current_user_account_id'].present?
          #             active_user_accounts.where(id: session['ss_current_user_account_id']).first&.account
          #           elsif active_user_accounts.count == 1
          #             active_user_accounts.first.account
          #           end

          if ua.present?
            # session['ss_current_user_account_id'] = ua.id
            set_current_tenant(ua.account)
            Current.active_user_account = ua
            # else
            #   session['ss_current_user_account_id'] = nil
          end
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
    # rubocop:enable Rails/ApplicationController

    # :nocov:
    def global_domain?
      return true if Rails.env.test?

      request.host.in? PgEngine.config.global_domains
    end
    # :nocov:

    include Pundit::Authorization
    include PrintHelper
    include PostgresHelper
    include FlashHelper
    include RouteHelper
    include PgAssociable::Helpers
    include FrameHelper

    class Redirect < PgEngine::Error
      attr_accessor :url

      def initialize(url)
        @url = url
        super
      end
    end

    rescue_from StandardError, with: :internal_error
    rescue_from ActsAsTenant::Errors::NoTenantSet, with: :no_tenant_set

    rescue_from PgEngine::BadUserInput, with: :bad_user_input
    rescue_from ActionController::UnknownFormat, with: :unknown_format

    rescue_from ActionController::InvalidAuthenticityToken,
                with: :invalid_authenticity_token

    rescue_from Pundit::NotAuthorizedError, with: :not_authorized
    rescue_from PgEngine::PageNotFoundError, with: :page_not_found
    rescue_from Redirect do |e|
      redirect_to e.url
    end

    def require_tenant_set
      return if ActsAsTenant.current_tenant.present?

      raise ActsAsTenant::Errors::NoTenantSet
    end

    def no_tenant_set(error)
      return internal_error(error) if Current.user.blank?

      active_user_accounts = Current.user.user_accounts.active.to_a
      if active_user_accounts.length == 1
        redirect_to url_for(tenant_id: active_user_accounts.first.to_param)
      else
        redirect_to users_accounts_path
      end
    end

    def bad_user_input(error)
      render_my_component(BadUserInputComponent.new(error_msg: error.message), :bad_request)
    end

    def unknown_format(_error)
      render_my_component(BadUserInputComponent.new(error_msg: 'Formato incorrecto'), :bad_request)
    end

    def internal_error(error)
      pg_err error

      render_my_component(InternalErrorComponent.new, :internal_server_error)
    end

    def invalid_authenticity_token(err)
      pg_warn err

      render_my_component(BadRequestComponent.new, :bad_request)
    end

    def page_not_found
      render_my_component(PageNotFoundComponent.new, :not_found)
    end

    # Para cachear el html y guardarlo en public/500.html
    def internal_error_but_with_status200
      render_my_component(InternalErrorComponent.new, :ok)
    end

    helper_method :dev_user_or_env?
    def dev_user_or_env?
      Rails.env.development? || dev_user?
    end

    helper_method :dev_user?
    def dev_user?
      Current.user&.developer?
    end

    helper_method :mobile_device?

    layout 'pg_layout/base'

    # Los flash_types resultantes serían:
    # [:critical, :alert, :notice, :warning, :success]
    add_flash_types :critical, :warning, :success

    before_action do
      console if dev_user_or_env? && (params[:show_web_console] || params[:wc])
    end

    before_action do
      @breakpoint_navbar_expand = 'md'
      navbar_expanded = cookies[:navbar_expand] != 'false'
      @navbar_opened_class = navbar_expanded ? 'opened' : ''
      @navbar_chevron_class = navbar_expanded ? 'bi-chevron-left' : 'bi-chevron-right'
      @navbar = Navbar.new

      if defined?(Rollbar) && Rollbar.configuration.enabled && Rails.application.credentials.rollbar.present?
        @rollbar_token = Rails.application.credentials.rollbar.access_token_client
      end

      if Current.user.present?
        # TODO: quitar el limit 3, discard en events
        @notifications = Current.user.notifications.order(id: :desc).includes(:event)
                                .where(type: 'SimpleUserNotifier::Notification')
                                .limit(3)
        unseen = @notifications.unseen.any?
        tooltip = @notifications.unseen.map(&:tooltip).select(&:presence).first
        @notifications_bell = NotificationsBellComponent.new(
          unseen:,
          tooltip:
        )
      end
    end

    def mobile_device?
      request.user_agent =~ /Mobile|webOS/
    end

    def pundit_user
      Current.user
    end

    protected

    def render_my_component(component, status)
      # Esto es para que saltee los turbo frames y genere
      # un full reload. El turbo_no_cache no es estrictamente necesario
      # pero lo dejo por las dudas
      @turbo_page_requires_reload = true
      @turbo_no_cache = true

      respond_to do |format|
        format.html do
          render component.alert_wrapped(view_context),
                 layout: 'pg_layout/centered',
                 status:
        end

        format.turbo_stream do
          flash.now[component.alert_type] = component.render_in(view_context)

          render turbo_stream: (turbo_stream.remove_all('.modal') +
                                render_turbo_stream_flash_messages),
                 status:
        end

        format.json do
          html = component.render_in(view_context)
          render json: { html: }, status:
        end

        format.any do
          head status
        end
      end
    end

    def not_authorized(_arg_required_for_active_admin)
      pg_warn <<~STRING
        Acceso no autorizado.
        User: #{Current.user.inspect}
        Request: #{request.inspect}
      STRING

      render_my_component(BadUserInputComponent.new(error_msg: 'Acceso no autorizado'), :unauthorized)
    end

    def go_back(message = nil, type: :alert)
      flash[type] = message if message.present?
      redirect_back fallback_location: root_path
    end
  end
  # rubocop:enable Metrics/ClassLength
end

module Users
  class InvitationsController < Devise::InvitationsController
    include PgEngine::TenantHelper

    before_action only: :new do
      # Porque el link for new no tiene turbo-frame="_top"
      @turbo_page_requires_reload = true
    end

    before_action only: %i[new create] do
      set_tenant_from_params_or_fail!

      authorize UserAccount

      add_breadcrumb Account.nombre_plural, users_accounts_path(tid: nil)
      add_breadcrumb ActsAsTenant.current_tenant, users_account_path(ActsAsTenant.current_tenant)
      add_breadcrumb UserAccount.nombre_plural
      add_breadcrumb UserAccount.new.decorate.submit_default_value

      @no_main_frame = true
    end

    def new
      self.resource = resource_class.new
      resource.user_accounts.build
      render :new
    end

    def create
      if params['user'].present? && params['user']['email'].present?
        email = params['user']['email']
        self.resource = ActsAsTenant.without_tenant do
          User.find_by(email:)
        end
      end

      if resource.present?
        if resource.kept?
          add_to_account(resource)
        else
          render_error(resource)
        end
      else
        super
      end
    end

    def after_invite_path_for(_inviter, _invitee)
      # tenant_user_accounts_path
      users_account_path(ActsAsTenant.current_tenant)
    end

    protected

    def render_error(_resource)
      new_user = User.new(invite_params)
      self.resource = new_user
      resource.errors.add(:email, 'pertenece a un usuario que no está disponible')
      render :new, status: :unprocessable_entity
    end

    def add_to_account(resource)
      new_user = User.new(invite_params)

      user_account = new_user.user_accounts.first
      user_account.invitation_status = :ist_invited
      resource.user_accounts << user_account
      if resource.valid?
        respond_with resource, location: after_invite_path_for(current_inviter, resource)
      else
        if user_account_exists?(resource)
          new_user.errors.add(:email, 'pertenece a un usuario de la cuenta')
        else
          new_user.errors.add(:base, resource.errors.full_messages.join(', '))
        end
        self.resource = new_user
        render :new, status: :unprocessable_entity
      end
    end

    def user_account_exists?(resource)
      first = resource.errors.first
      first.present? && first.attribute == :'user_accounts.user_id' && first.type == :taken
    end
  end
end

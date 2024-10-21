module PgEngine
  class DeviseController < ApplicationController
    prepend_before_action only: :create do
      rate_limiting(
        to: 10,
        within: 1.hour,
        by: -> { request.remote_ip },
        with: -> { head :too_many_requests },
        store: cache_store
      )
    end

    before_action :configure_permitted_parameters
    before_action do
      @no_main_frame = true
    end

    layout :layout_by_user

    protected

    def layout_by_user
      user_signed_in? ? 'pg_layout/containerized' : 'pg_layout/devise'
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[nombre apellido accept_terms])
      devise_parameter_sanitizer.permit(:account_update, keys: %i[nombre apellido])
      devise_parameter_sanitizer.permit(:invite, keys: [{ user_accounts_attributes: [:id, :_destroy, :account_id, { profiles: [] }] }])
    end
  end
end

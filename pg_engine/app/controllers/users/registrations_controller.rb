module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action do
      authorize resource, nil, policy_class: UserRegistrationPolicy
    end

    def create
      build_resource(sign_up_params)

      ActiveRecord::Base.transaction do
        resource.save
        yield resource if block_given?
        if resource.persisted?
          create_account_for(resource) if ActsAsTenant.current_tenant.blank?

          expire_data_after_sign_in!
          render_message
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
      end
    end

    def render_message
      msg = <<~HTML
        <div class="alert alert-info mt-4 d-inline-block">
          #{I18n.t 'devise.registrations.signed_up_but_unconfirmed'}
        </div>
      HTML
      render turbo_stream: turbo_stream.update('form-signup', msg)
    end

    private

    def create_account_for(user)
      account = Account.create!(nombre: user.email)
      user.user_accounts.create!(account:)
    end
  end
end

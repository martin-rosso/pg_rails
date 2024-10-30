module Users
  class InvitationsController < Devise::InvitationsController
    before_action only: %i[new create] do
      add_breadcrumb 'Cuentas', ->(h) { h.users_accounts_path(tenant_id: nil) }
      add_breadcrumb ActsAsTenant.current_tenant, users_account_path(ActsAsTenant.current_tenant)
      add_breadcrumb 'Agregar usuario'
      @sidebar = false
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
        add_to_account(resource)
      else
        super
      end
    end

    def after_invite_path_for(_inviter, _invitee)
      users_account_path(ActsAsTenant.current_tenant)
    end

    protected

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

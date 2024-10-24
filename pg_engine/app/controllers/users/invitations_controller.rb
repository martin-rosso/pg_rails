module Users
  class InvitationsController < Devise::InvitationsController
    before_action do
      @no_main_frame = nil
    end

    before_action only: :new do
      if params[:account_id].blank?
        error_msg = 'Solicitud incorrecta'
        render_my_component(BadUserInputComponent.new(error_msg:), :bad_request)
      end
    end

    def new
      self.resource = resource_class.new
      self.resource.user_accounts.build(account_id: params[:account_id])
      render :new
    end

    def create
      user = nil

      if params['user'].present? && params['user']['email'].present?
        email = params['user']['email']
        user = ActsAsTenant.without_tenant do
          User.find_by(email:)
        end
      end

      if user.present?
        new_user = User.new(invite_params)
        user.user_accounts << new_user.user_accounts
        respond_with user, location: after_invite_path_for(current_inviter, user)
      else
        byebug
        super
      end
    end

    def after_invite_path_for(inviter, invitee)
      users_account_path(ActsAsTenant.current_tenant)
    end
  end
end

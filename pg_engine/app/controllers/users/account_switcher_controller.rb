module Users
  class AccountSwitcherController < PgEngine.config.users_controller
    rescue_from ActsAsTenant::Errors::NoTenantSet, with: :internal_error
    skip_before_action :require_tenant_set

    before_action do
      @no_main_frame = true
    end

    layout 'pg_layout/centered'

    def list
      @user_accounts = Current.user.user_accounts
    end

    def switch
      user_account = UserAccount.find(params[:user_account_id])
      session['current_user_account'] = user_account.id
      redirect_to root_path
    end
  end
end

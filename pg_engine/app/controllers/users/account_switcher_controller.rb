module Users
  class AccountSwitcherController < PgEngine.config.users_controller
    rescue_from ActsAsTenant::Errors::NoTenantSet, with: :internal_error
    skip_before_action :require_tenant_set

    before_action do
      @no_main_frame = true
      # @sidebar = false
      @breadcrumbs_on_rails = []
    end

    layout 'pg_layout/centered'

    around_action :set_without_tenant

    def set_without_tenant(&)
      ActsAsTenant.without_tenant(&)
    end

    def list
      @user_accounts = Current.user.user_accounts.kept.where(membership_status: :active)
      @invitations = Current.user.user_accounts.kept.where(membership_status: :invited)
    end

    def switch
      # FIXME: handle not found
      scope = Current.user.user_accounts.kept
      user_account = scope.find(UserAccount.decode_id(params[:user_account_id]))
      session['current_user_account'] = user_account.id
      redirect_to root_path
    end
  end
end

module PgEngine
  class BaseUsersController < ApplicationController
    include PgEngine::RequireSignIn

    before_action do
      # TODO!: requisito que esto esté seteado
      Current.namespace = :users

      @other_active_accounts = ActsAsTenant.without_tenant do
        Current.user.user_accounts.ua_active.to_a
      end
      @sidebar = false
    end
  end
end

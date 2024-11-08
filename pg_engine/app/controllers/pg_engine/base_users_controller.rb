module PgEngine
  class BaseUsersController < ApplicationController
    include PgEngine::RequireSignIn

    before_action do
      # TODO!: requisito que esto esté seteado
      Current.namespace = :users

      # FIXME: ver que esto esté en todas las pantallas en que esté signed in, ej: en la home y en mi perfil
      # desduplicar en tenant controller
      @other_active_accounts = ActsAsTenant.without_tenant do
        Current.user.user_accounts.ua_active.to_a
      end
      @sidebar = false
    end
  end
end

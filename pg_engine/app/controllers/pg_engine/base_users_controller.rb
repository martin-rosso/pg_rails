module PgEngine
  class BaseUsersController < ApplicationController
    include PgEngine::RequireSignIn

    before_action do
      # TODO!: requisito que esto esté seteado
      Current.namespace = :users
      @sidebar = false
    end
  end
end

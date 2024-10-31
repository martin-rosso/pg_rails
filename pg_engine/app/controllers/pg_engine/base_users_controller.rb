module PgEngine
  class BaseUsersController < ApplicationController
    include PgEngine::RequireSignIn
    include PgEngine::RequireTenantSet

    before_action do
      # TODO!: requisito que esto esté seteado
      Current.namespace = :users

      add_breadcrumb 'Inicio', :users_root_path unless using_modal2? || frame_embedded?
    end
  end
end

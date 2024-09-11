module PgEngine
  class BaseUsersController < ApplicationController
    include PgEngine::RequireSignIn
    include PgEngine::RequireTenantSet

    before_action do
      # FIXME: requisito que esto esté seteado
      Current.namespace = :users

      add_breadcrumb 'Inicio', :users_root_path unless using_modal2? || frame_embedded?
    end

    def home
      render html: '<h1>Inicio</h1>'.html_safe, layout: 'pg_layout/centered'
    end
  end
end

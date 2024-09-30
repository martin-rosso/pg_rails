module Users
  class DashboardController < PgEngine.config.users_controller
    layout 'pg_layout/containerized'

    def dashboard
      add_breadcrumb 'Resumen'
    end
  end
end

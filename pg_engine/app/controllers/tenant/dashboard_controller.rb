module Tenant
  class DashboardController < PgEngine::TenantController
    layout 'pg_layout/containerized'

    def dashboard
      add_breadcrumb 'Resumen'
    end
  end
end

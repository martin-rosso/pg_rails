# frozen_string_literal: true

module PgEngine
  module RequireTenantSet
    def self.included(klass)
      klass.before_action :require_tenant_set
    end

    def require_tenant_set
      return if ActsAsTenant.current_tenant.present?

      redirect_to users_account_switcher_path
    end
  end
end

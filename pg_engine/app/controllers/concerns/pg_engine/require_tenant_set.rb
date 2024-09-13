# frozen_string_literal: true

module PgEngine
  module RequireTenantSet
    def self.included(klass)
      klass.before_action :require_tenant_set
    end

    def require_tenant_set
      return if ActsAsTenant.current_tenant.present?

      raise ActsAsTenant::Errors::NoTenantSet
    end
  end
end

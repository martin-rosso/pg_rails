# frozen_string_literal: true

module PgEngine
  module RequireTenantSet
    def self.included(klass)
      klass.before_action :require_tenant_set
    end
  end
end

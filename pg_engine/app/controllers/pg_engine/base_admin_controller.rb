module PgEngine
  class BaseAdminController < ApplicationController
    include PgEngine::RequireSignIn

    before_action do
      raise Pundit::NotAuthorizedError unless Current.user&.developer?

      Current.namespace = :admin

      add_breadcrumb 'Admin'
    end

    around_action :set_without_tenant

    def set_without_tenant
      ActsAsTenant.without_tenant do
        # Monkeypatch to force url_options to be regenerated
        # FIXME: maybe set default_url_options?
        @_url_options = nil

        yield
      end
    end
  end
end

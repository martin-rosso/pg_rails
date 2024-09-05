class FrontendController < ApplicationController
  include PgEngine::RequireSignIn

  # FIXME: tal vez esto debería ir en BaseController
  set_current_tenant_through_filter

  before_action do
    # FIXME: requisito que esto esté seteado
    Current.namespace = :frontend
    add_breadcrumb 'Frontend'

    if ActsAsTenant.current_tenant.nil?
      # FIXME: remove Current.account
      set_current_tenant(Current.account)
    end
  end
end

# FIXME!: mover a pg_engine
class AdminController < ApplicationController
  include PgEngine::RequireSignIn

  before_action do
    # FIXME: asegurar la bocha (hay que quitar el login_as de UsersController)
    # raise Pundit::NotAuthorizedError unless Current.user&.developer?
    raise Pundit::NotAuthorizedError if Current.user.present? && !dev_user?

    Current.namespace = :admin

    add_breadcrumb 'Admin'
  end

  around_action :set_without_tenant

  def set_without_tenant(&)
    ActsAsTenant.without_tenant(&)
  end
end

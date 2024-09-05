class FrontendController < ApplicationController
  include PgEngine::RequireSignIn

  before_action do
    # FIXME: requisito que esto esté seteado
    Current.namespace = :frontend
    add_breadcrumb 'Frontend'
  end
end

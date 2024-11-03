class ApplicationController < PgEngine::BaseController
  include ActionView::Helpers::AssetTagHelper

  before_action do
    @navbar.logo = { partial: 'layouts/logo', locals: { image_url: 'procura-logo-navbar-1.png' } }
    @navbar.logo_xl_url = 'procura-logo-xl-light.png'
  end
end

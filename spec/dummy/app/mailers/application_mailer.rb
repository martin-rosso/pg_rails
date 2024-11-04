class ApplicationMailer < PgEngine::BaseMailer
  before_action do
    @footer_image_alt = I18n.t(Current.app_name, scope: 'app_name')
    @footer_image_src = 'footer-mail-dark-light.png'
    @footer_href = root_url
  end
end

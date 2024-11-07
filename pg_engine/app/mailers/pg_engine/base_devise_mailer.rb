module PgEngine
  class BaseDeviseMailer < ApplicationMailer
    layout 'pg_layout/devise_mailer'

    def logo_footer_name
      PgEngine.site_brand.mailer_devise_footer_image_src
    end
  end
end

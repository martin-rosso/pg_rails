module PgEngine
  class BaseDeviseMailer < ApplicationMailer
    before_action do
      @footer_image_src = 'mail-footer-lg.png'
    end

    layout 'pg_layout/devise_mailer'
  end
end

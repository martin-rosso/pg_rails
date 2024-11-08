module PgEngine
  class BaseMailer < ActionMailer::Base # rubocop:disable Rails/ApplicationMailer
    class MailNotDelivered < StandardError; end

    def default_url_options
      super.merge(PgEngine.site_brand.default_url_options)
    end

    before_action { @email_object = params[:email_object] }

    before_action do
      path = Rails.application.assets.find_asset(logo_footer_name).filename
      png_data = File.read(path)
      attachments.inline[logo_footer_name] = png_data
      @footer_image_src = attachments[logo_footer_name].url
    end

    def logo_footer_name
      PgEngine.site_brand.mailer_base_footer_image_src
    end

    default from: lambda { |_mailer|
                    if @email_object.present?
                      email_address_with_name(@email_object.from_address, @email_object.from_name)
                    else
                      email_address_with_name(PgEngine.site_brand.default_mail_from,
                                              PgEngine.site_brand.default_mail_from_name)
                    end
                  },
            reply_to: ->(_mailer) { @email_object.reply_to if @email_object.present? },
            subject: ->(_mailer) { @email_object.subject if @email_object.present? },
            to: ->(_mailer) { @email_object.to if @email_object.present? }

    layout 'pg_layout/mailer'

    # default delivery_method: :smtp

    rescue_from StandardError do |err|
      pg_err err
      # TODO: agregar un backtrace
      @email_object.update_columns(status: :failed, status_detail: err.to_s) if @email_object.present?
    end

    protected

    def mail(*args)
      super.tap do |message|
        # message.mailgun_options = {
        #   'tag' => email.tags,
        #   'tracking-opens' => true
        # }
        message['email_object'] = @email_object if @email_object.present?
      end
    end
  end
end

#   # TODO: testear
#       si from está vacío
#       si body está vacío

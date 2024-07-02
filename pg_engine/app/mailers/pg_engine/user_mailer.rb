module PgEngine
  class UserMailer < ApplicationMailer
    # default delivery_method: :smtp

    def notification
      recipient = params[:notification].recipient
      @html = params[:message].html_safe
      @text = params[:message_text]
      mail(to: recipient.email, subject: params[:subject])
    end
  end
end

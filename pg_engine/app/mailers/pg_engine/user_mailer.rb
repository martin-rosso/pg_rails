module PgEngine
  class UserMailer < ApplicationMailer
    # default delivery_method: :smtp

    def notification
      @recipient = params[:notification].recipient
      @html = replace_user(params[:message]).html_safe
      @text = replace_user(params[:message_text])
      mail(to: @recipient.email, subject: params[:subject])
    end

    def replace_user(input)
      # reemplaza todas las ocurrencias de: %{user}
      format(input, user: @recipient.nombre)
    end
  end
end

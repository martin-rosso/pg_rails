# frozen_string_literal: true

# generado con pg_rails

module Admin
  class EmailsController < AdminController
    include PgEngine::Resource

    self.clase_modelo = Email

    before_action(only: :index) { authorize Email }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Email.nombre_plural, :admin_emails_path

    after_action only: :create do
      if @saved
        PgEngine::AdminMailer.with(email_object: @email).admin_mail.deliver_later
      end
    end

    private

    def atributos_permitidos
      %i[status from_address from_name reply_to to subject body_input associated_id associated_type]
    end

    def atributos_para_buscar
      %i[accepted_at delivered_at opened_at from_address from_name reply_to to subject body_input tags
         message_id mailer status_detail status]
    end

    def atributos_para_listar
      %i[from_address to subject body_input tags associated status]
    end

    def atributos_para_mostrar
      %i[message_id status status_detail accepted_at delivered_at opened_at from_address
         from_name reply_to to subject body_input tags associated mailer encoded_eml_link]
    end
  end
end

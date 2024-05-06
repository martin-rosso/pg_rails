# frozen_string_literal: true

# generado con pg_rails

module Users
  class EmailsController < UsersController
    include PgEngine::Resource

    before_action { @clase_modelo = Email }

    before_action(only: :index) { authorize Email }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb Email.nombre_plural, :users_emails_path

    private

    def atributos_permitidos
      %i[from_address from_name reply_to to subject body_input associated_id associated_type]
    end

    def atributos_para_buscar
      %i[accepted_at delivered_at opened_at from_address from_name reply_to to subject body_input tags content_eml
         message_id mailer status_detail status]
    end

    def atributos_para_listar
      %i[from_address to subject body_input tags associated status]
    end

    def atributos_para_mostrar
      %i[accepted_at delivered_at opened_at from_address from_name reply_to to subject body_input tags associated
         content_eml message_id mailer status_detail status]
    end
  end
end

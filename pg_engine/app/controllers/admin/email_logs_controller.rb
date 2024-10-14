# frozen_string_literal: true

# generado con pg_rails

module Admin
  class EmailLogsController < AdminController
    include PgEngine::Resource

    self.clase_modelo = EmailLog

    before_action(only: :index) { authorize EmailLog }

    before_action do
      @actions = [
        ["Mailgun sync: #{ENV.fetch('MAILGUN_DOMAIN', nil)}", mailgun_sync_admin_email_logs_path, {
          'data-turbo-method': :post, class: 'me-2 btn btn-primary btn-sm'
        }]
      ]
    end

    def mailgun_sync
      @new_items = PgEngine::Mailgun::LogSync.download
      flash[:success] = "#{@new_items.length} nuevos items"

      redirect_to admin_email_logs_path
    end

    private

    def atributos_permitidos
      %i[email_id log_id event log_level severity timestamp message_id]
    end

    def atributos_para_buscar
      %i[email log_id event log_level severity timestamp message_id]
    end

    def atributos_para_listar
      %i[email log_id event log_level severity timestamp message_id]
    end

    def atributos_para_mostrar
      %i[email log_id event log_level severity timestamp message_id]
    end
  end
end

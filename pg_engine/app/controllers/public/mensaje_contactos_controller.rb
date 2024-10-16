# frozen_string_literal: true

# generado con pg_rails

module Public
  class MensajeContactosController < PublicController
    prepend_before_action only: :create do
      rate_limiting(
        to: 3,
        within: 1.hour,
        by: -> { request.remote_ip },
        with: -> { head :too_many_requests },
        store: cache_store
      )
    end

    include PgEngine::Resource

    self.clase_modelo = MensajeContacto

    layout 'pg_layout/container_logo'

    def new; end

    def create
      if Current.user.present?
        @mensaje_contacto.email = Current.user.email
        @mensaje_contacto.nombre = Current.user.nombre_completo
      end
      if @mensaje_contacto.save
        render turbo_stream: turbo_stream.update('mensaje_contacto', partial: 'gracias')
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def atributos_permitidos
      %i[nombre email telefono mensaje]
    end
  end
end

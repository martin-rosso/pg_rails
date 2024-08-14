# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CategoriaDeCosasController < AdminController
    include PgEngine::Resource

    before_action :set_clase_modelo
    def set_clase_modelo
      @clase_modelo = CategoriaDeCosa
    end

    before_action(only: :index) { authorize CategoriaDeCosa }

    # Para testear la progress bar en turbo frames
    before_action(only: :show) { sleep 1 }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb CategoriaDeCosa.nombre_plural, :admin_categoria_de_cosas_path

    private

    def default_page_size
      15
    end

    def atributos_permitidos
      %i[nombre tipo fecha tiempo].push(cosas_attributes: %i[id nombre tipo _destroy])
    end

    def atributos_para_buscar
      %i[nombre tipo_in fecha tiempo]
    end

    def atributos_para_listar
      [
        :nombre_f,
        [:tipo_text, %i[tipo fecha]],
        :cosas_f,
        :fecha,
        :tiempo
      ]
    end

    def atributos_para_mostrar
      %i[nombre tipo fecha tiempo]
    end
  end
end

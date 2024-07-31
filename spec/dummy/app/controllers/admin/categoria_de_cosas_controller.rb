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

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb CategoriaDeCosa.nombre_plural, :admin_categoria_de_cosas_path

    private

    def atributos_permitidos
      %i[nombre tipo fecha tiempo].push(cosas_attributes: %i[id nombre tipo _destroy])
    end

    def atributos_para_buscar
      %i[nombre_cont tipo_in fecha_eq tiempo]
    end

    def atributos_para_listar
      %i[nombre_f tipo_text cosas_f fecha tiempo]
    end

    def atributos_para_mostrar
      %i[nombre tipo fecha tiempo]
    end
  end
end

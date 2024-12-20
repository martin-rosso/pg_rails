# frozen_string_literal: true

# generado con pg_rails

module Admin
  class CategoriaDeCosasController < AdminController
    include PgEngine::Resource
    self.clase_modelo = CategoriaDeCosa

    def column_options_for(object, attribute)
      if attribute == :nombre_f
        { class: 'column-truncate-80', title: object.send(attribute) }
      else
        super
      end
    end

    private

    def default_page_size
      15
    end

    def atributos_permitidos
      %i[account_id nombre tipo fecha tiempo].push(cosas_attributes: %i[id nombre tipo _destroy])
    end

    def atributos_para_buscar
      %i[account nombre tipo_in fecha tiempo]
    end

    def atributos_para_listar
      [
        [:account, %i[account_nombre]],
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

# frozen_string_literal: true

# generado con pg_rails

module Users
  class CosasController < UsersController
    include PgEngine::Resource

    self.clase_modelo = Cosa
    self.nested_class = CategoriaDeCosa
    self.nested_key = :categoria_de_cosa_id

    before_action(only: :index) { authorize Cosa }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    def column_options_for(object, attribute)
      case attribute
      when :nombre
        { class: 'column-truncate-80', title: object.send(attribute).to_s }
      else
        super
      end
    end

    private

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id]
    end

    def atributos_para_buscar
      %i[nombre tipo categoria_de_cosa]
    end

    def atributos_para_listar
      %i[nombre tipo_text categoria_de_cosa]
    end

    def atributos_para_mostrar
      %i[nombre tipo categoria_de_cosa]
    end
  end
end

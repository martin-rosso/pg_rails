# frozen_string_literal: true

# generado con pg_rails

module Tenant
  class CosasController < PgEngine::TenantController
    include PgEngine::Resource

    self.clase_modelo = Cosa
    self.nested_class = CategoriaDeCosa
    self.nested_key = :categoria_de_cosa_id

    def column_options_for(object, attribute)
      case attribute
      when :nombre
        { class: 'column-truncate-30', title: object.send(attribute).to_s }
      when :rico
        { class: 'column-truncate-40', title: object.send(attribute).to_s }
      else
        super
      end
    end

    def index
      @collection = filtros_y_policy(atributos_para_buscar)

      # FIXME: quitar sufijo en filtrosbuilder
      case params[:custom_options]
      when 'enum_values'
        options = [Cosa.tipo.completar, Cosa.tipo.los]
        @filtros.configure(:tipo_eq, { options: })
      when 'hash'
        options = [
          ['Uno', 1],
          ['Dos', 2]
        ]
        @filtros.configure(:tipo_eq, { options: })
      end

      # no puede ser includes, porque ya hay un join con carpeta (kept) entonces
      # haría el join con responsable también

      @collection = @collection.preload(:creado_por)
      pg_respond_index(archived: false)
    end

    private

    def atributos_permitidos
      %i[nombre tipo categoria_de_cosa_id rico creado_por_id]
    end

    def atributos_para_buscar
      %i[nombre tipo categoria_de_cosa creado_por]
    end

    def atributos_para_listar
      %i[nombre tipo_text categoria_de_cosa creado_por]
    end

    def atributos_para_mostrar
      %i[nombre tipo categoria_de_cosa creado_por]
    end
  end
end

# frozen_string_literal: true

module PgEngine
  module IndexHelper
    def encabezado(input, options = {})
      if input.is_a? Array
        campo = input.first
        sort_field = input.last
      else
        campo = sort_field = input
      end

      campo = campo.to_s.sub(/_f\z/, '')
      campo = campo.to_s.sub(/_text\z/, '')
      sort_field = sort_field.to_s.sub(/_f\z/, '')
      sort_field = sort_field.to_s.sub(/_text\z/, '')

      clase = options[:clase] || @clase_modelo
      key = [controller_name, action_name, 'listado_header', campo].join('.')
      dflt = :"activerecord.attributes.#{clase.model_name.i18n_key}.#{campo}"
      human_name = clase.human_attribute_name(key, default: dflt)

      if options[:ordenable]
        sort_link(@q, sort_field, human_name, default_order: default_order(campo))
      else
        human_name
      end
    end

    def default_order(campo)
      columna = @clase_modelo.columns.find { _1.name == campo.to_s }
      if columna && columna.type.to_s.include?('date')
        :desc
      else
        :asc
      end
    rescue StandardError => e
      pg_err e

      :asc
    end
  end
end

# frozen_string_literal: true

module PgEngine
  module IndexHelper
    def column_for(object, attribute)
      content_tag :td, **column_options_for(object, attribute) do
        render InlineShowComponent.new(object.object, attribute)
      end
    end

    SUFIJOS = %i[f text].freeze
    def unsuffixed(attribute, sufijos = SUFIJOS)
      ret = attribute.to_s.dup

      sufijos.each do |sufijo|
        ret.gsub!(/_#{sufijo}$/, '')
      end

      ret
    end

    def unsuffixed_for_export(attribute)
      unsuffixed(attribute, %i[f])
    end

    def encabezado(input, options = {})
      if input.is_a? Array
        campo = unsuffixed(input.first)
        sort_field = input.last
      else
        campo = sort_field = unsuffixed(input)
      end

      clase = options[:clase] || @clase_modelo

      human_name = scoped_human_attr_name(clase, campo, 'listado_header')

      if options[:ordenable]
        if sort_field.is_a? Array
          sort_link(@q, sort_field.first, sort_field, human_name, default_order: default_order(campo))
        else
          sort_link(@q, sort_field, human_name, default_order: default_order(campo))
        end
      else
        human_name
      end
    end

    def scoped_human_attr_name(clase, campo, scope)
      action_key = build_scoped_key(clase, campo, scope, action_name)
      scope_key = build_scoped_key(clase, campo, scope)

      I18n.t(action_key, default: [scope_key, clase.human_attribute_name(campo)])
    end

    def build_scoped_key(clase, campo, scope = nil, subscope = nil)
      campo = "#{campo}/scoped" if scope.present?
      scope = "#{subscope}/#{scope}" if subscope.present?

      ['activerecord.attributes', clase.model_name.i18n_key, campo, scope].compact.join('.').to_sym
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

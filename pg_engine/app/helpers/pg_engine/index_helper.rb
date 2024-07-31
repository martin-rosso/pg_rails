# frozen_string_literal: true

module PgEngine
  module IndexHelper
    def encabezado(campo, options = {})
      campo = campo.to_s.sub(/_f\z/, '')
      campo = campo.to_s.sub(/_text\z/, '')
      clase = options[:clase] || @clase_modelo
      key = [controller_name, action_name, 'listado_header', campo].join('.')
      dflt = :"activerecord.attributes.#{clase.model_name.i18n_key}.#{campo}"
      human_name = clase.human_attribute_name(key, default: dflt)
      if options[:ordenable]
        field = controller.instance_variable_get(:@field)
        direction = controller.instance_variable_get(:@direction)
        uri = URI.parse(request.url)
        cgi = if uri.query.present?
                CGI.parse(uri.query)
              else
                {}
              end
        cgi['order_by'] = campo
        cgi['order_direction'] =
          if field.to_s == campo.to_s && direction.to_s == 'desc'
            'asc'
          else
            'desc'
          end

        symbol = if field.to_s == campo.to_s
                   if direction.to_s == 'asc'
                     '<i class="bi bi-sort-down-alt" />'
                   elsif direction.to_s == 'desc'
                     '<i class="bi bi-sort-up" />'
                   end
                 else
                   ''
                 end

        uri.query = cgi.transform_values { |b| (b.length == 1 ? b.first : b) }.to_query

        link_to(human_name, uri.to_s) + " #{symbol}".html_safe
      else
        human_name
      end
    end
  end
end

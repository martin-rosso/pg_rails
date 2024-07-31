# frozen_string_literal: true

# generado con pg_rails

<% if false && namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
<% module_namespacing_2 do -%>
class <%= controller_class_name.split('::').last %>Controller < <%= parent_controller %>
  include PgEngine::Resource

  before_action { @clase_modelo = <%= class_name.split('::').last %> }

  before_action(only: :index) { authorize <%= class_name.split('::').last %> }

  before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

  add_breadcrumb <%= class_name.split('::').last %>.nombre_plural, :<%= plural_route_name %>_path

  private

  def atributos_permitidos
    %i[<%= attributes_names.join(' ') %>]
  end

  def atributos_para_buscar
    # FIXME: append _cont
    %i[<%= atributos_a_filtrar.map(&:name).join(' ') %>]
  end

  def atributos_para_listar
    %i[<%= atributos_a_filtrar.map(&:name).join(' ') %>]
  end

  def atributos_para_mostrar
    %i[<%= atributos_a_filtrar.map(&:name).join(' ') %>]
  end
end
<% end -%>
<% end -%>

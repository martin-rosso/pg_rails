# frozen_string_literal: true

# generado con pg_rails

<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action { @clase_modelo = <%= class_name %> }

  before_action(only: :index) { authorize <%= class_name %> }

  before_action :set_<%= singular_name %>, only: %i[new create show edit update destroy]

  add_breadcrumb <%= class_name %>.nombre_plural, :<%= plural_table_name %>_path

  def index
    @<%= plural_name %> = filtros_y_policy %i[<%= atributos_a_filtrar.map(&:name).join(' ') %>]

    pg_respond_index(@<%= plural_name %>)
  end

  def show
    add_breadcrumb @<%= singular_name %>, @<%= singular_name %>

    respond_to do |format|
      format.json { render json: @<%= singular_name %> }
      format.html
    end
  end

  def new
    add_breadcrumb "Crear #{<%= class_name %>.nombre_singular.downcase}"
  end

  def edit
    add_breadcrumb @<%= singular_name %>
  end

  def create
    pg_respond_create(@<%= singular_name %>)
  end

  def update
    pg_respond_update(@<%= singular_name %>)
  end

  def destroy
    pg_respond_destroy(@<%= singular_name %>, <%= index_helper %>_url)
  end

  private

    def render_smart_listing
      smart_listing(:<%= plural_name %>, @<%= plural_name %>, '<%= ruta_vistas %>/listing',
                    sort_attributes: [
                      <%- for attribute in attributes -%>
                      [:<%= attribute.name %>, '<%= attribute.name %>'],
                      <%- end -%>
                    ])
    end

    def set_<%= singular_name %>
      if action_name.in? %w[new create]
        @<%= singular_name %> = @clase_modelo.new(<%= "#{singular_name}_params" %>)
      else
        @<%= singular_name %> = @clase_modelo.find(params[:id])

        @<%= singular_name %>.assign_attributes(<%= "#{singular_name}_params" %>) if action_name.in? %w[update]
      end

      @<%= singular_name %>.current_user = current_user

      authorize @<%= singular_name %>

      @<%= singular_name %> = @<%= singular_name %>.decorate if action_name.in? %w[show new edit]
    end

    def <%= "#{singular_name}_params" %>
      <%- if attributes_names.empty? -%>
      params.fetch(:<%= singular_table_name %>, {})
      <%- else -%>
      if action_name == 'new'
        params.permit(atributos_permitidos)
      else
        params.require(:<%= singular_table_name %>).permit(atributos_permitidos)
      end
      <%- end -%>
    end

    def atributos_permitidos
      %i[<%= attributes_names.join(' ') %>]
    end
end
<% end -%>

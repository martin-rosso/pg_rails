# generado con pg_rails

require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ruta_vistas %>/new", <%= type_metatag(:view) %> do
  PgEngine::ConfiguradorRSpec.helpers(self)
<% if mountable_engine? -%>
  helper <%= mountable_engine? %>::Engine.routes.url_helpers
<% end -%>

  let(:user) { create(:user, :developer) }

  before(:each) do
    sign_in user
    @<%= singular_name %> = assign(:<%= singular_name %>, build(:<%= nombre_tabla_completo_singular %>).decorate)
    @clase_modelo = assign(:clase_modelo, <%= nombre_clase_completo %>)
  end

  it "renders new <%= ns_file_name %> form" do
    render

    assert_select "form[action=?][method=?]", <%= index_helper %>_path, "post" do
<% for attribute in output_attributes -%>
      <%- name = attribute.respond_to?(:column_name) ? attribute.column_name : attribute.name %>
<% if Rails.version.to_f >= 5.1 -%>
      assert_select "<%= attribute.input_type -%>[name=?]", "<%= ns_file_name %>[<%= name %>]"
<% else -%>
      assert_select "<%= attribute.input_type -%>#<%= ns_file_name %>_<%= name %>[name=?]", "<%= ns_file_name %>[<%= name %>]"
<% end -%>
<% end -%>
    end
  end
end

require 'rails_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
RSpec.describe "<%= ns_table_name %>/new", <%= type_metatag(:view) %> do
  before(:each) do
    @<%= singular_name %> = assign(:<%= singular_name %>, build(:<%= ns_file_name %>))
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

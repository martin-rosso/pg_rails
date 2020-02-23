# generado con pg_rails

<% module_namespacing do -%>
class <%= class_name %> < <%= parent_class_name.classify %>
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %><%= ', polymorphic: true' if attribute.polymorphic? %><%= ', required: true' if attribute.required? %><%= ", class_name: '#{attribute.clase_con_modulo}'" if attribute.tiene_modulo? %>
<% end -%>
<% attributes.select(&:token?).each do |attribute| -%>
  has_secure_token<% if attribute.name != "token" %> :<%= attribute.name %><% end %>
<% end -%>
<% if attributes.any?(&:password_digest?) -%>
  has_secure_password
<% end -%>
<% if attributes.any? { |at| at.required? } -%>
  validates <%= attributes.select { |at| at.required? }.map { |at| ":#{at.name}" }.join(', ') %>, presence: true
<% end -%>
end
<% end -%>

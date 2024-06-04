class InternalErrorComponent < BaseComponent
  def self.alert_type
    :critical
  end

  erb_template <<~ERB
    <div>
      <div class="mb-1">
        <%= @error_msg || 'Ocurrió algo inesperado' %>
      </div>
      Por favor, intentá nuevamente
      <br>
      o <a class="text-decoration-underline" href="<%= new_public_mensaje_contacto_path %>">dejá un mensaje</a>
      para que te avisemos
      <br>
      cuando el problema esté resuelto 🙏
    </div>
  ERB
end

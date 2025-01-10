class FlashContainerComponent < ViewComponent::Base
  # z-1 es para que no se superponga con el dropdown de la navbar,
  # ya que sticky-top setea un z-index de 1020 y el del dropdown es de 1000
  erb_template <<~HTML
    <div id="flash-container" class="d-flex justify-content-around sticky-top z-1">
      <div id="flash" class="flash position-relative w-100 d-flex justify-content-center">
        <%= content || render(partial: 'pg_layout/flash') %>
      </div>
    </div>
  HTML
end

class ModalContentComponent < ViewComponent::Base
  def initialize(src: nil, turbo_frame_id: :modal_content)
    @turbo_frame_id = turbo_frame_id
    @src = src
    with_content(loading_html) if @src.present?

    super
  end

  def loading_html
    <<~HTML.html_safe
      <div class="text-center text-body-secondary fs-3" style="min-height: 15em">
        Cargando...
      </div>
    HTML
  end

  erb_template <<~ERB
    <div class="modal-body">
      <div class="d-flex justify-content-around sticky-top">
        <div class="flash position-relative w-100 d-flex justify-content-center">
        </div>
      </div>
      <%= helpers.turbo_frame_tag @turbo_frame_id,
                                  **{ src: @src, refresh: :morph }.compact do %>
        <%= content %>
      <% end %>
    </div>
  ERB
end

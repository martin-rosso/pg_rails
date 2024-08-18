class ModalContentComponent < ViewComponent::Base
  renders_one :actions
  renders_one :body
  renders_one :header

  def before_render
    controller.instance_variable_set(:@using_modal, true)
  end

  erb_template <<~ERB
    <%= helpers.turbo_frame_tag :modal_generic do %>
      <div class="modal-header">
        <%= header %>
        <a class="btn-close" type="button" data-bs-dismiss="modal" aria-label="Close"></a>
      </div>
      <div class="modal-body">
        <div class="d-flex justify-content-around sticky-top">
          <div class="flash position-relative w-100 d-flex justify-content-center">
          </div>
        </div>
        <div class="float-end">
          <%= actions %>
        </div>
        <%= body %>
      </div>
    <% end %>
  ERB
end

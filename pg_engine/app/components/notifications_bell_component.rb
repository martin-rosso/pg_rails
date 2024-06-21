class NotificationsBellComponent < BaseComponent
  def initialize(tooltip:, unseen:)
    @tooltip = tooltip
    @unseen = unseen
    super
  end

  erb_template <<~ERB
    <div>
      <% if @tooltip.present? %>
        <div class="d-none d-sm-inline-block text-white pg--notifications-bell--tooltip">
          <%= @tooltip %>
        </div>
      <% end %>
      <button type="button" class="btn btn-primary btn-sm position-relative"
                            data-bs-toggle="collapse" data-bs-target="#notifications-collapse">
        <i class="bi-bell-fill fs-5 text-light"></i>
        <% if @unseen %>
          <span class="position-absolute p-1 xbg-danger bg-gradient rounded-circle start-50 notifications-unseen-mark">
          </span>
        <% end %>
      </button>
    </div>
  ERB
end

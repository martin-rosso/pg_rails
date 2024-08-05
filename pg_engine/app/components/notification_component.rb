class NotificationComponent < BaseComponent
  def initialize(notification: nil)
    @notification = notification
    super
  end

  erb_template <<~ERB
    <div class="notification d-flex flex-column flex-sm-row justify-content-between <%= 'unseen' if @notification.unseen? %>"
         id="<%= dom_id(@notification) %>" data-id="<%= @notification.id %>">
      <div class="pe-3 trix-content">
        <%= @notification.message.html_safe %>
      </div>
      <div class="notification--time d-flex flex-column justify-content-end text-body-tertiary text-end">
        <div>
          hace
          <%= distance_of_time_in_words @notification.created_at, Time.zone.now %>
        </div>
        <div>
          <a href="javascript:void" class="link-opacity-50" data-action="notifications#markAsUnseen">Marcar como no leído</a>
        </div>
      </div>
    </div>
  ERB
end

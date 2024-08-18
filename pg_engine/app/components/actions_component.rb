class ActionsComponent < ViewComponent::Base
  def initialize(record)
    @record = record.decorate

    super
  end

  erb_template <<~ERB
    <div>
      <%= @record.edit_link %>
      <%= @record.destroy_link_redirect %>
    </div>
  ERB
end

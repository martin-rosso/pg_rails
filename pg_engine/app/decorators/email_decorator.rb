# frozen_string_literal: true

# generado con pg_rails

class EmailDecorator < PgEngine::BaseDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def content_eml_link
    link_to 'Download', helpers.content_eml_admin_email_path(object), target: :_blank
  end
end

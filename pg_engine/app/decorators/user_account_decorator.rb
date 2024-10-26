# frozen_string_literal: true

# generado con pg_rails

class UserAccountDecorator < PgEngine::BaseRecordDecorator
  delegate_all

  def estado_f
    if object.user.invited_to_sign_up?
      content_tag :span, 'Invitación enviada',
                  class: 'text-warning-emphasis fw-bold'
    else
      content_tag :span, 'Activo', class: 'text-success fw-bold'
    end
  end

  def profiles_f
    object.profiles.texts.join(', ')
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end

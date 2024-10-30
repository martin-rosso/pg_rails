# frozen_string_literal: true

# generado con pg_rails

class UserAccountDecorator < PgEngine::BaseRecordDecorator
  delegate_all

  def estado_f
    if membership_status.active? && invitation_status.invited?
      content_tag :span, object.invitation_status_text, class: 'text-warning-emphasis fw-bold'
    else
      # if membership_status.disabled? || invitation_status.accepted?
      klass = {
        'active' => 'text-success',
        'disabled' => 'text-danger'
      }[object.membership_status]

      content_tag :span, object.membership_status_text, class: "#{klass} fw-bold"
    end
  end

  def profiles_f
    object.profiles.texts.join(', ')
  end
end

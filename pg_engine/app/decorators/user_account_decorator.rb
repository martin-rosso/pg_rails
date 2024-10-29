# frozen_string_literal: true

# generado con pg_rails

class UserAccountDecorator < PgEngine::BaseRecordDecorator
  delegate_all

  def estado_f
    klass = {
      'active' => 'text-success',
      'disabled' => 'text-danger',
      'invited' => 'text-warning-emphasis'
    }[object.membership_status]

    content_tag :span, object.membership_status_text, class: "#{klass} fw-bold"
  end

  def profiles_f
    profiles.join(', ')
  end
end

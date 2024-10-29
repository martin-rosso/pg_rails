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
    return if object.profiles.account__owner?

    aux = object.profiles.map do |pro|
      parts = pro.split('__')
      [parts.first, parts.last]
    end

    aux = aux.group_by(&:first).map do |group, permisos|
      "<b>#{group}</b>: #{permisos.map(&:last).join(', ')}"
    end

    aux.join('. ').html_safe
  end
end

# frozen_string_literal: true

# generado con pg_rails

class UserAccountDecorator < PgEngine::BaseRecordDecorator
  delegate_all
  def nested_record
    return unless Current.namespace == :users

    object.account
  end

  def ingresar_link
    return unless Pundit.policy!(Current.user, object).ingresar?

    h.link_to h.users_root_path(tenant_id: object.to_param),
              'data-turbo-frame': :_top,
              class: 'btn btn-sm btn-success' do
      'Ingresar'
    end
  end

  def accept_invitation_link
    return unless Pundit.policy!(Current.user, object).accept_invitation_link?

    h.link_to [:update_invitation, target_object, { accept: 1 }].flatten,
              'data-turbo-method': :put,
              class: 'btn btn-sm btn-success' do
      'Aceptar invitación'
    end
  end

  def reject_invitation_link
    return unless Pundit.policy!(Current.user, object).accept_invitation_link?

    h.link_to [:update_invitation, target_object, { reject: 1 }].flatten,
              'data-turbo-method': :put,
              class: 'btn btn-sm btn-danger' do
      'Rechazar'
    end
  end

  def sign_off_link
    return unless Pundit.policy!(Current.user, object).sign_off?

    h.link_to [:update_invitation, target_object, { sign_off: 1 }].flatten,
              'data-turbo-method': :put,
              class: 'btn btn-sm btn-outline-danger' do
      'Dejar la cuenta'
    end
  end

  def estado_f
    membership_status_f + ' - ' + invitation_status_f
  end

  def membership_status_f
    klass = {
      'ms_active' => 'text-success',
      'ms_disabled' => 'text-danger'
    }[object.membership_status]

    content_tag :span, object.membership_status_text, class: "#{klass} fw-bold"
  end

  def invitation_status_f
    klass = {
      'ist_accepted' => 'text-success',
      'ist_invited' => 'text-warning-emphasis',
      'ist_rejected' => 'text-danger',
      'ist_signed_off' => 'text-danger'
    }[object.invitation_status]

    content_tag :span, object.invitation_status_text, class: "#{klass} fw-bold"
  end

  def profiles_f
    object.profiles.texts.join(', ')
  end
end

# frozen_string_literal: true

# generado con pg_rails

class AccountDecorator < PgEngine::BaseRecordDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def extra_actions(*)
    return if Current.namespace == :admin

    ua = Current.user.user_account_for(object).decorate
    [ua.ingresar_link,
     ua.accept_invitation_link,
     ua.reject_invitation_link].compact.join.html_safe
  end

  def show_link(text: nil, klass: 'btn-secondary')
    return unless Pundit.policy!(Current.user, object).show?

    text = 'Usuarios' # rubocop:disable Lint/ShadowedArgument

    helpers.content_tag :span do
      helpers.link_to object_url, class: "btn btn-sm #{klass}" do
        helpers.content_tag(:span, nil, class: clase_icono('person')) + text
      end
    end
  end

  def logo_f
    if logo.present?
      image_tag logo.variant(:thumb), style: 'max-height:3em'
    else
      content_tag 'i', nil, class: 'bi bi-bag-fill text-center d-inline-block', style: 'font-size: 1.7em; width: 1.6em'
    end
  end
end

# frozen_string_literal: true

# generado con pg_rails

class EmailDecorator < PgEngine::BaseRecordDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def status_f
    klass = "badge align-content-center #{status_badge_class}"
    content_tag :span, id: dom_id(object, :status), class: klass do
      status_text
    end
  end

  def status_text
    {
      'pending' => 'Enviando',
      'failed' => 'Falló',
      'sent' => 'Enviando',
      'accepted' => 'Enviando',
      'delivered' => 'Entregado',
      'rejected' => 'Falló'
    }[object.status]
  end

  def status_badge_class
    {
      'pending' => 'text-bg-warning',
      'failed' => 'text-bg-danger',
      'sent' => 'text-bg-warning',
      'accepted' => 'text-bg-warning',
      'delivered' => 'text-bg-success',
      'rejected' => 'text-bg-danger'
    }[object.status]
  end

  def encoded_eml_link
    return if object.encoded_eml.blank?

    link_to 'Download', helpers.rails_blob_path(object.encoded_eml),
            target: :_blank, rel: :noopener
  end
end

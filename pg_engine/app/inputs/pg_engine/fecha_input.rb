# frozen_string_literal: true

module PgEngine
  class FechaInput < SimpleForm::Inputs::StringInput
    def input(wrapper_options = nil)
      # esto es porque si no Rails llama a value_before_type_cast
      value = if object.is_a? Draper::Decorator
                # Salteo el decorator para que me tome la fecha con formato inglés
                object.object.public_send(attribute_name)
              else
                object.public_send(attribute_name)
              end

      @input_type = 'date'

      options = merge_wrapper_options({ value:, class: '', autocomplete: 'off' },
                                      wrapper_options)
      if input_options[:date_selector]
        content_tag 'div', class: 'd-flex align-items-center' do
          super(options) + date_selector
        end
      else
        super(options)
      end
    end

    include ActionView::Helpers::FormTagHelper
    def date_selector
      field_id = @builder.field_id(attribute_name)
      html = DateSelectorComponent.new(field_id).render_in(@builder.template)
      # tabindex required: https://getbootstrap.com/docs/5.3/components/popovers/#dismiss-on-next-click
      link_to 'javascript:void(0)',
              class: 'btn btn-link', tabindex: 0,
              data: {
                controller: 'popover-toggler',
                'bs-html': true,
                'bs-title': 'Cambiar la fecha',
                'bs-content': html
              } do
        '<i class="bi bi-magic"></i>'.html_safe
      end
    end
  end
end

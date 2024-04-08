# frozen_string_literal: true

class PgFormBuilder < SimpleForm::FormBuilder
  include PgAssociable::FormBuilderMethods
  include PgEngine::ErrorHelper

  def default_prefix(attribute_name)
    at_name = object.class.human_attribute_name(attribute_name.to_s).downcase
    "#{articulo(attribute_name)} #{at_name}"
  end

  def articulo(attribute_name)
    gender = I18n.t("gender.#{attribute_name}", default: nil)
    if gender.present?
      gender == 'f' ? 'La' : 'El'
    else
      at_name = object.class.human_attribute_name(attribute_name.to_s).downcase
      at_name.ends_with?('a') ? 'La' : 'El'
    end
  end

  def input(attribute_name, options = {}, &)
    options[:error_prefix] ||= default_prefix(attribute_name)

    super(attribute_name, options, &)
  end

  def mensajes_de_error
    title = error_notification(message: mensaje, class: 'text-danger mb-2 error-title') if mensaje

    base_errors = object.errors[:base]
    base_message = (base_errors.map(&:to_s).join('<br>') if base_errors.present?)
    base_tag = error_notification(message: base_message, class: 'alert alert-danger') if base_message

    all_errors_tag = build_all_errors_tag unless base_tag

    title + base_tag + all_errors_tag
  end

  def build_all_errors_tag
    details = object.errors.details.dup
    details.delete(:base)
    not_base_errors = details.any?

    return unless not_base_errors

    # TODO!: poder pasar un block para que no se ejecute si no se va a loguear por el log level
    pg_warn "Not base errors en pg_form: #{object.errors.details}. Record: #{object.inspect}", :debug

    # rubocop:disable Rails/OutputSafety
    "<span class='not_base_errors' data-errors='#{object.errors.details.to_json}'></span>".html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def mensaje
    scope = error_message_for(object, associations:)
    return if scope.blank?

    I18n.t("simple_form.error_notification.#{scope}")
  end

  def associations
    object.class.reflect_on_all_associations
          .select { |a| a.instance_of? ActiveRecord::Reflection::HasManyReflection }
          .map(&:name)
  end

  map_type :date, to: PgEngine::FechaInput
  # map_type :datetime, to: PgEngine::FechaInput

  def submit_button(*args, &)
    options = args.extract_options!.dup
    options[:class] = ['btn-primary', options[:class]].compact
    args << options
    send(:submit, *args, &)
  end
end

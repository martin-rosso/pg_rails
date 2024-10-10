# frozen_string_literal: true

class PgFormBuilder < SimpleForm::FormBuilder
  include PgAssociable::FormBuilderMethods
  include PgEngine::ErrorHelper

  def default_prefix(attribute_name)
    attribute_name = attribute_name.to_s.sub(/_id\z/, '')
    at_name_human = object.class.human_attribute_name(attribute_name).downcase
    "#{articulo(attribute_name)} #{at_name_human}"
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

    super
  end

  def field(attribute_name, options = {}, &)
    model = convert_to_model(object)

    if find_on_all_associations(model.class, attribute_name).present?
      pg_associable(attribute_name, options)
    else
      input(attribute_name, options, &)
    end
  end

  def find_on_all_associations(klass, campo)
    return unless klass.respond_to? :reflect_on_all_associations

    klass.reflect_on_all_associations.find do |a|
      a.name == campo.to_sym
    end
  end

  def mensajes_de_error
    # TODO: quitar en before-cache?
    title = error_notification(message: mensaje, class: 'text-danger mb-2 error-title') if mensaje

    base_errors = object.errors[:base]
    base_message = (base_errors.map(&:to_s).join('<br>') if base_errors.present?)
    base_tag = error_notification(message: base_message, class: 'alert alert-danger') if base_message

    "#{title}#{base_tag}".html_safe
  end

  def mensaje
    scope = error_message_for(object, associations:)
    return if scope.blank?

    I18n.t("simple_form.error_notification.#{scope}")
  end

  def associations
    return [] unless object.class.respond_to?(:reflect_on_all_associations)

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

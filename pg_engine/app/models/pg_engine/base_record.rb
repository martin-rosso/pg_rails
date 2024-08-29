# frozen_string_literal: true

module PgEngine
  # rubocop:disable Rails/ApplicationRecord
  class BaseRecord < ActiveRecord::Base
    # rubocop:enable Rails/ApplicationRecord
    extend Enumerize
    include PrintHelper
    include PostgresHelper

    self.abstract_class = true

    before_create :setear_creado_y_actualizado_por
    before_update :setear_actualizado_por

    class << self
      # This is a per class variable, all subclasses of BaseRecord inherit it
      # BUT **the values are independent between all of them**
      attr_accessor :default_modal
    end

    scope :query, ->(param) { param.present? ? where(id: param) : all }

    def self.ransackable_associations(_auth_object = nil)
      authorizable_ransackable_associations
    end

    def self.ransackable_attributes(_auth_object = nil)
      authorizable_ransackable_attributes
    end

    def gender
      self.class.model_name.human.downcase.ends_with?('a') ? 'f' : 'm'
    end

    def self.nombre_plural
      model_name.human(count: 2)
    end

    def self.nombre_singular
      model_name.human(count: 1)
    end

    def self.human_attribute_name(attribute, options = {})
      if attribute.to_s.ends_with?('_text')
        # Si es un enumerized
        super(attribute[0..-6], options)
      elsif attribute.to_s.ends_with?('_f')
        # Si es un decorated method
        super(attribute[0..-3], options)
      else
        super
      end
    end

    def actions_component
      ActionsComponent.new(self)
    end

    # Para el dom_id (index.html)
    def to_key
      if respond_to? :hashid
        [hashid]
      else
        super
      end
    end

    def to_s
      %i[nombre name].each do |campo|
        # Using `_in_database` for consistent breadcrumbs when editing the name
        campo = :"#{campo}_in_database"

        return "#{send(campo)} ##{to_param}" if try(campo).present?
      end
      if to_param.present?
        "#{self.class.nombre_singular} ##{to_param}"
      else
        super
      end
    end

    private

    def setear_creado_y_actualizado_por
      setear_si_existe :creado_por, Current.user
      setear_si_existe :actualizado_por, Current.user
    end

    def setear_actualizado_por
      setear_si_existe :actualizado_por, Current.user
    end

    def setear_si_existe(campo, valor)
      metodo = "#{campo}="
      send(metodo, valor) if respond_to?(metodo) && valor.present?
    end
  end
end

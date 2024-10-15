module PgEngine
  module Naming
    deprecate :gender, deprecator: PgEngine.deprecator
    def gender
      self.class.model_name.human.downcase.ends_with?('a') ? 'f' : 'm'
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # This is a per class variable, all subclasses of BaseRecord inherit it
      # BUT **the values are independent between all of them**
      attr_accessor :default_modal, :inline_editable_fields

      def gender
        model_name.human.downcase.ends_with?('a') ? 'f' : 'm'
      end

      def inline_editable?(attribute)
        inline_editable_fields.present? && inline_editable_fields.include?(attribute.to_sym)
      end

      def ransackable_associations(_auth_object = nil)
        authorizable_ransackable_associations
      end

      def ransackable_attributes(_auth_object = nil)
        authorizable_ransackable_attributes
      end

      def nombre_plural
        model_name.human(count: 2)
      end

      def nombre_singular
        model_name.human(count: 1)
      end

      def human_attribute_name(attribute, options = {})
        # Remove suffixes
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
    end
  end
end

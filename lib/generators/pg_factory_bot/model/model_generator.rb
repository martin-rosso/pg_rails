# este generator tiene que llamarse ModelGenerator para que funcione el hook_to
# del ModelGenerator de rails

require 'generators/factory_bot/model/model_generator'

module PgFactoryBot
  module Generators
    class ModelGenerator < FactoryBot::Generators::ModelGenerator

      # piso el método de FactoryBot::Generators::Base con el método original
      # de Rails::Generators::Base
      def self.source_root(path = nil)
        @_source_root = path if path
        @_source_root ||= default_source_root
      end

      source_root File.expand_path('templates', __dir__)

      class_option(
        :dir,
        type: :string,
        default: "spec/factories",
        desc: "The directory or file root where factories belong",
      )

      # este método es igual al de FactoryBot::Generators::Base
      # pero si no lo pongo acá pone las clases sin el prefijo del módulo
      def explicit_class_option
        return if nombre_clase_completo == singular_table_name.camelize

        ", class: '#{nombre_clase_completo}'"
      end

      def nombre_clase_completo
        if namespaced?
          (namespaced_class_path + [file_name]).map!(&:camelize).join("::")
        else
          (regular_class_path + [file_name]).map!(&:camelize).join("::")
        end
      end

      private

        # Genero los valores de las factories con los helpers de Faker

        def factory_attributes
          attributes.map do |attribute|
            if attribute.reference?
              "#{attribute.name}_id { create(:#{attribute.tabla_referenciada_singular}).id }"
            else
              "#{attribute.name} { #{valor_atributo(attribute)} }"
            end
          end.join("\n")
        end

        def valor_atributo(attribute)
          if attribute.type == :string
            "Faker::Lorem.sentence"
          elsif attribute.type == :date
            "Faker::Date.backward"
          elsif attribute.type == :float || attribute.type == :decimal
            "Faker::Number.decimal(l_digits: 3, r_digits: 2)"
          elsif attribute.es_enum?
            "#{nombre_clase_completo}.#{attribute.name}.values.sample"
          else
            attribute.default.inspect
          end
        end
    end
  end
end

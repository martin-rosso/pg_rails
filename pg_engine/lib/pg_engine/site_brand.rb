# frozen_string_literal: true

module PgEngine
  class SiteBrand
    def self.configurations
      raise 'not implemented'
    end

    def self.default_site_brand
      raise 'not implemented'
    end

    def default_site_brand
      self.class.default_site_brand
    end

    def self.define_methods_for_symbols
      configurations.each do |name, options|
        define_method(name) do
          if options.keys.include?(Current.app_name)
            options[Current.app_name]
          elsif options.keys.include?(:default)
            options[:default]
          elsif default_site_brand.present? && options.keys.include?(default_site_brand)
            pg_warn('Default site brand chosen')

            options[default_site_brand]
          else
            raise PgEngine::Error, 'No site brand found'
          end
        end
      end
    end
  end
end

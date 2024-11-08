# frozen_string_literal: true

module PgEngine
  class SiteBrand
    attr_accessor :default_site_brand

    def initialize
      @options = {}
    end

    def value_for(key)
      options = @options[key.to_sym]

      raise PgEngine::Error, 'Key not found' if options.nil?

      if Current.app_name.present? && options.keys.include?(Current.app_name)
        options[Current.app_name]
      elsif options.keys.include?(:default)
        options[:default]
      elsif default_site_brand.present? && options.keys.include?(default_site_brand)
        pg_warn('Default site brand chosen')

        options[default_site_brand]
      else
        # :nocov:
        raise PgEngine::Error, 'No site brand found'
        # :nocov:
      end
    end

    def method_missing(method)
      value_for(method)
    end

    def respond_to_missing?(method, include_private)
      @options.key?(method.to_sym) or super
    end
  end
end

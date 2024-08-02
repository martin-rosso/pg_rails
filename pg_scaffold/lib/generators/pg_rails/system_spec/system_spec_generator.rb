# frozen_string_literal: true

module PgRails
  class SystemSpecGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def copy_application_policy
      template 'system_spec.rb', "spec/system/#{file_name}.rb"
    end

    private

    def file_name
      "#{name.downcase.gsub(' ', '_')}_spec"
    end
  end
end

# frozen_string_literal: true

# Maintain your gem's version:
require_relative "pg_rails/lib/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name                  = 'pg_rails'
  spec.version               = PgRails::VERSION
  spec.authors               = ['Martín Rosso']
  spec.email                 = ['mrosso10@gmail.com']
  spec.homepage              = 'https://github.com/programandoarg/pg_rails'
  spec.summary               = 'Rails goodies'
  spec.description           = 'Rails goodies.'
  spec.license               = 'MIT'
  spec.required_ruby_version = '~> 3.0'

  spec.require_paths = ['pg_rails/lib', 'pg_associable/lib', 'pg_engine/lib', 'pg_layout/lib', 'pg_scaffold/lib']
  spec.files = Dir['{pg_associable,pg_engine,pg_layout,pg_scaffold,pg_rails}/**/*', 'MIT-LICENSE', 'README.md']

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = ": Set to 'http://mygemserver.com'"
  # else
  #   raise 'RubyGems 2.0 or newer is required to protect against ' \
  #     'public gem pushes.'
  # end
  spec.add_dependency 'rails', "~> 7.2.0"
  spec.add_dependency 'anycable', "= 1.5.1"
  spec.add_dependency 'anycable-rails', "~> 1.5.1"
  spec.add_dependency 'anycable-rails-jwt', "~> 0.2.0"
  spec.add_dependency 'cable_ready', "~> 5.0"

  spec.add_dependency 'caxlsx_rails', "~> 0.6.3"

  spec.add_dependency 'draper', "~> 4.0.2"

  spec.add_dependency 'pg', '~> 1.5.4'

  spec.add_dependency 'rainbow', "~> 3.1.1"

  spec.add_dependency 'simple_form', "~> 5.3.0"

  # User manamement
  # Al updatear, chequear los controllers overrideados
  spec.add_dependency 'devise', "~> 4.9.3"
  spec.add_dependency 'devise-i18n', "~> 1.12.0"

  # Rails internationalization
  spec.add_dependency 'rails-i18n', "~> 7.0.8"

  # Slim template
  spec.add_dependency 'slim-rails', "~> 3.6.3"

  # Better enums
  spec.add_dependency 'enumerize', "~> 2.8.1"

  # XML parsing
  spec.add_dependency 'nokogiri', "~> 1.16"

  # Pagination
  spec.add_dependency 'kaminari', "~> 1.2.2"
  spec.add_dependency 'kaminari-i18n', "~> 0.5.0"

  # Breadcrumbs
  spec.add_dependency 'breadcrumbs_on_rails', '~> 4.1.0'

  # Soft deletion
  spec.add_dependency 'discard', "~> 1.3.0"

  # DB Audition
  spec.add_dependency 'audited', "~> 5.7.0"

  # Access policies
  spec.add_dependency 'pundit', "~> 2.3.1"

  # Dotenv
  spec.add_dependency 'dotenv-rails', "~> 3.1.0"

  spec.add_dependency 'puma', "~> 6.4"
  spec.add_dependency 'rollbar', "~> 3.5.1"

  spec.add_dependency 'sprockets-rails', "~> 3.5"

  spec.add_dependency 'jsbundling-rails', "~> 1.3"
  spec.add_dependency 'cssbundling-rails', "~> 1.3"

  spec.add_dependency 'turbo-rails', "~> 2.0"

  spec.add_dependency 'activeadmin', "~> 3.2.2"

  spec.add_dependency 'sassc', "~> 2.4.0"

  spec.add_dependency 'image_processing', "~> 1.2"
  spec.add_dependency 'hashid-rails', "~> 1.0"

  # Use Redis adapter to run Action Cable in production
  spec.add_dependency 'redis', '~> 5.1'

  spec.add_dependency "kredis", "~> 1.7.0"
  spec.add_dependency 'mailgun-ruby', '~> 1.2.14'

  # Full text search
  spec.add_dependency 'pg_search', "~> 2.3.6"

  # Ransack memory
  spec.add_dependency 'ransack', '~> 4.2.1'
  spec.add_dependency 'ransack_memory', '~> 0.1'

  spec.add_dependency 'view_component', '~> 3.13'

  # Notifications
  spec.add_dependency 'noticed', '~> 2.3'

end

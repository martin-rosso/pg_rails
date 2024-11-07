# frozen_string_literal: true

require_relative 'pg_engine/engine'
require_relative 'pg_engine/core_ext'
require_relative 'pg_engine/error'
require_relative 'pg_engine/configuracion'
require_relative 'pg_engine/site_brand'
require_relative 'pg_engine/navigator'
require_relative 'pg_engine/active_job_extensions'
require_relative 'pg_engine/email_observer'
require_relative 'pg_engine/mailgun/log_sync'
require_relative 'pg_engine/route_helpers'
require_relative 'pg_engine/utils/pg_logger'
require_relative 'pg_engine/utils/pdf_preview_generator'

require_relative '../app/helpers/pg_engine/print_helper'

require 'rails'
require 'anycable'
require 'anycable-rails'
require 'anycable-rails-jwt'
require 'acts_as_tenant'
require 'cable_ready'
require 'caxlsx_rails'
require 'draper'
require 'pg'
require 'rainbow'
require 'simple_form'
require 'devise'
require 'devise-i18n'
require 'devise_invitable'
require 'rails-i18n'
require 'slim-rails'
require 'enumerize'
require 'nokogiri'
require 'kaminari'
require 'kaminari-i18n'
require 'breadcrumbs_on_rails'
require 'discard'
require 'audited'
require 'pundit'
require 'dotenv-rails'
require 'puma'
require 'rollbar'
require 'sprockets/rails'
require 'jsbundling-rails'
require 'cssbundling-rails'
require 'turbo-rails'
require 'sassc'
require 'image_processing'
require 'hashid/rails'
require 'redis'
require 'kredis'
require 'mailgun-ruby'
require 'pg_search'
require 'view_component'
require 'noticed'
require 'ransack'
require 'ransack_memory'
require 'holidays'
require 'faye/websocket'
require 'eventmachine'

if Rails.env.local?
  require 'letter_opener'
  require 'overcommit'
  require 'database_cleaner-active_record'
  require 'byebug'
  require 'annotate'
  require 'bullet'
  require 'rubocop'
  require 'rubocop-rails'
  require 'rubocop-rspec'
  require 'slim_lint'
  require 'brakeman'
  require 'capybara'
  require 'selenium-webdriver'
  require 'simplecov'
  # require 'spring'
  # require 'spring-commands-rspec'
  require 'rspec-rails'
  require 'factory_bot_rails'
  require 'faker'
  require 'rails-controller-testing'
end

module PgEngine
  class << self
    attr_writer :configuracion, :site_brand

    def configuracion
      @configuracion ||= Configuracion.new
    end

    def site_brand
      @site_brand || (raise PgEngine::Error, 'no site brand manager')
    end

    def config
      configuracion
    end

    def configurar
      yield(configuracion)
    end
  end

  def self.redis_url(host: '127.0.0.1', port: '6379')
    env_value = ENV.fetch('TEST_ENV_NUMBER', nil)
    db = (env_value.nil? ? 1 : (env_value.presence || 1)).to_i - 1
    "redis://#{host}:#{port}/#{db}"
  end

  GOOGLE_FONTS_URL =
    <<~URL.chomp
      https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,300;0,400;\
      0,500;0,700;1,300;1,400;1,500;1,700&display=swap
    URL

  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new('7.5', 'PgEngine')
  end
end

ActiveSupport.on_load(:active_job) do |base|
  base.prepend PgEngine::ActiveJobExtensions
end

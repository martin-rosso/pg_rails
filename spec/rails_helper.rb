# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'simplecov'

if ENV.fetch('LCOV', false)
  require 'simplecov-lcov'
  require 'undercover'

  SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
end

SimpleCov.start 'rails' do
  add_filter do |src|
    src.filename =~ /pg_engine\/app\/admin/
  end
  add_filter do |src|
    src.filename =~ /initializers\/rollbar.rb/
  end
  add_filter %r{^/app/admin/}

  if ENV['BRANCH_COV'] == '1'
    enable_coverage(:branch) # Report branch coverage to trigger branch-level undercover warnings
  end
end

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
# require_relative '../config/environment'
require File.expand_path('dummy/config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

require "view_component/test_helpers"
require "view_component/system_test_helpers"
require 'capybara/rails'
require 'capybara/rspec'

require "rails/generators"
require "rails/generators/testing/behavior"
require "rails/generators/testing/setup_and_teardown"
require "rails/generators/testing/assertions"
require "fileutils"

require "parallel_tests"

Capybara.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i

if ParallelTests.first_process?
  DatabaseCleaner.clean_with(:truncation)
else
  sleep 2
end

require 'pg_rails/capybara_support'
require 'pg_rails/redis_support'
require 'pg_rails/vcr_support'
require 'pg_rails/pundit_matchers'
require 'pg_rails/rspec_logger_matchers'
require 'pg_rails/tom_select_helpers'
require 'pg_rails/tpath_support'
require 'pg_rails/draper_support'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('..', '..', 'spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
require 'factory_bot_rails'
require 'devise'
# require 'enumerize'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # ActsAsTenant
  config.before(:suite) do |example|
    # Make the default tenant globally available to the tests
    $default_account = FactoryBot.create(:account)
  end

  config.before(:each) do |example|
    Current.reset

    if example.metadata[:type].in? %i(request controller system)
      # Set the `test_tenant` value for integration tests
      ActsAsTenant.test_tenant = $default_account
      # ActsAsTenant.current_tenant = $default_account
    else
      # Otherwise just use current_tenant
      ActsAsTenant.current_tenant = $default_account
    end
  end

  config.after(:each) do |example|
    # Clear any tenancy that might have been set
    ActsAsTenant.current_tenant = nil
    ActsAsTenant.test_tenant = nil
  end

  # Selenium
  config.before(:each, type: :system) do
    driven_by ENV.fetch('DRIVER', :selenium_chrome_headless_iphone).to_sym, using: ENV.fetch('BROWSER', :headless_chrome).to_sym
  end
  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://rspec.info/features/6-0/rspec-rails
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  #

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers

  config.include Rails::Generators::Testing::Behavior, type: :generator
  config.include Rails::Generators::Testing::SetupAndTeardown, type: :generator
  config.include Rails::Generators::Testing::Assertions, type: :generator
  config.include FileUtils, type: :generator
  config.include PgEngine::Matchers
  config.include PgEngine::TpathSupport
  config.include PgEngine::TpathSupport::RequestsPatch, tpath_req: true
  config.include PgEngine::TpathSupport::ControllersPatch, tpath_cont: true

  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Capybara::RSpecMatchers, type: :request

  config.include PgRails::TomSelectHelpers, type: :system
  # config.include ActiveSupport::Testing::TimeHelpers
end

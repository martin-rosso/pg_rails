# VCR
group :test do
  gem 'vcr', '~> 6.2.0'
  gem 'webmock', '~> 3.20.0'
  # Capybara
  gem 'capybara', '~> 3.40.0'
  gem 'capybara-lockstep', '~> 2.2'
  gem 'selenium-webdriver', '~> 4.17.0'
end

# Misc
group :development, :test do
  gem 'database_cleaner-active_record', '~> 2.1.0'
  gem 'byebug', '~> 11.1'

  # Spring
  gem 'spring', '~> 4.1.3'
  gem 'spring-commands-rspec', '~> 1.0.4'

  # Rspec
  gem 'rspec-rails', '~> 6.0.4'
  gem 'factory_bot_rails', '~> 6.4.3'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'faker', '~> 3.2.3'
  gem 'parallel_tests', '~> 4.7'

  # Coverage
  gem 'simplecov', '~> 0.22.0'
  gem 'simplecov-lcov', '~> 0.8.0'
  gem 'undercover', '~> 0.5.0'
end

# Misc
group :development do
  gem 'overcommit', '~> 0.64'
  gem 'letter_opener', '~> 1.8.1'
  gem 'annotate', '~> 3.2.0'
  gem 'web-console', '~> 4.2.1'
  gem 'stimulus-rails', '~> 1.3.3'

  # Bullet
  gem 'bullet', '~> 7.1.6'

  # Linters
  gem 'rubocop', '~> 1.64'
  gem 'rubocop-rails', '~> 2.25'
  gem 'rubocop-rspec', '~> 3.0'
  gem 'rubocop-capybara', '~> 2.21'
  gem 'rubocop-factory_bot', '~> 2.26'
  gem 'rubocop-rspec_rails', '~> 2.30'
  gem 'slim_lint', '~> 0.26.0'
  gem 'ruby-lint', '~> 0.9.1'
  gem 'brakeman', '~> 6.1'
  gem 'bundler-audit', '~> 0.9.1'
end

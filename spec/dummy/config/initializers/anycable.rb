# frozen_string_literal: true

# Add Warden middleware to AnyCable stack to allow accessing
# Devise current user via `env["warden"].user`.
#
# See https://docs.anycable.io/ruby/authentication
#
# NOTE: This is only needed in environments where you use AnyCable.
if defined?(AnyCable::Rails)
  AnyCable::Rails::Rack.middleware.use Warden::Manager do |config|
    Devise.warden_config = config
  end
end

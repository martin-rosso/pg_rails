pg_deprecation(
  'requiring current_attributes_support',
  'instead use "include ActiveSupport::CurrentAttributes::TestHelper" when necessary',
  deprecator: PgEngine.deprecator
)

RSpec.configure do |config|
  config.before(:each) do
    Current.user = nil
    Current.namespace = nil
  end
end

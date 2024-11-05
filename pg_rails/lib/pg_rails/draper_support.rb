RSpec.configure do |config|
  config.before(:each, type: :job) { Draper::ViewContext.clear! }
end

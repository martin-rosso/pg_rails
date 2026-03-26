require 'rails_helper'

describe PgEngine::HealthChecker do
  let(:health_checker) { described_class.new }
  let(:doub) { double }

  before do
    PgEngine.config.health_checks = []
  end

  it "checks the extras" do
    allow(doub).to receive(:bla)
    PgEngine.configurar do |config|
      config.add_health_check(:dummy_check) do
        doub.bla
      end
    end
    health_checker.run_checks(only: ["dummy_check"])
    expect(doub).to have_received(:bla)
  end

  it "error is descriptive" do
    PgEngine.configurar do |config|
      config.add_health_check(:dummy_check) do
        raise "sth went wrong"
      end
    end
    expect do
      health_checker.run_checks(only: ["dummy_check"])
    end.to raise_error(/Health check failed: dummy_check/)
  end
end

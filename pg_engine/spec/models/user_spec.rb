# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user, :owner) }

  it 'se persiste' do
    expect(user).to be_persisted
    expect(UserAccount.unscoped.count).to eq 1
    expect(UserAccount.first.profiles).to include(:account__owner)
  end

  it do
    expect(user.default_account).to be_present
  end

  describe 'search ransacker' do
    it 'searchs' do
      results = described_class.ransack(search_cont: user.nombre).result.to_a
      expect(results).to eq [user]
    end
  end
end

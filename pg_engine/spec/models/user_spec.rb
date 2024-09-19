# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }

  it 'se persiste' do
    expect(user).to be_persisted
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

  describe 'default scope' do
    before do
      ActsAsTenant.current_tenant = nil
      ActsAsTenant.test_tenant = nil
      Current.reset
    end

    it 'scopes according to tenant' do
      account = create(:account)
      other_account = create(:account)
      usr1 = usr2 = usr3 = usr4 = nil
      ActsAsTenant.with_tenant(other_account) do
        usr3 = create(:user)
        usr4 = create(:user)
      end
      ActsAsTenant.with_tenant(account) do
        usr1 = create(:user)
        usr2 = create(:user)
        expect(described_class.all).to contain_exactly(usr1, usr2)
      end
      expect(described_class.all).to contain_exactly(usr1, usr2, usr3, usr4)
    end
  end
end

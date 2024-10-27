# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

RSpec.describe UserAccount do
  let(:user_account) { create(:user_account) }

  it 'se persiste' do
    ActsAsTenant.without_tenant do
      expect(user_account).to be_persisted
      expect(User.count).to eq 1
      expect(described_class.count).to eq 1
    end
  end
end

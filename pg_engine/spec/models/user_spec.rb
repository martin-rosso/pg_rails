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

  context 'si es orphan' do
    let(:user) { create(:user, orphan: true) }

    it do
      expect(user.accounts).to be_empty
    end

    it do
      expect { user.default_account }.to raise_error(User::Error)
    end
  end

  context 'Si falla la creación de cuenta, que rollbackee la transaction de create user' do
    # rubocop:disable Lint/SuppressedException
    subject do
      user.save
    rescue User::Error
    end
    # rubocop:enable Lint/SuppressedException

    let(:user) do
      build(:user)
    end

    before do
      # rubocop:disable RSpec/MessageChain
      allow(user).to receive_message_chain(:user_accounts, :create) {
                       instance_double(UserAccount, persisted?: false)
                     }
      # rubocop:enable RSpec/MessageChain
    end

    it do
      expect { subject }.not_to change(described_class, :count)
    end

    it do
      subject
      expect(user).not_to be_persisted
    end
  end

  describe 'search ransacker' do
    it 'searchs' do
      results = described_class.ransack(search_cont: user.nombre).result.to_a
      expect(results).to eq [user]
    end
  end
end

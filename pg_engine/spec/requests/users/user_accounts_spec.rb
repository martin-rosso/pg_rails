require 'rails_helper'

describe 'Devise invitable' do
  let(:logged_user) { create :user }

  before do
    sign_in logged_user
  end

  describe 'destroy' do
    subject do
      delete "/u/user_accounts/#{user_account.id}"
    end

    let(:user_account) { create :user_account }

    it do
      expect { subject }.to change(UserAccount.unscoped, :count).by(-1)
    end
  end
end

require 'rails_helper'

describe 'Devise invitable' do
  let(:logged_user) { create :user }

  before do
    sign_in logged_user
  end

  describe 'destroy' do
    subject do
      delete "/u/user_accounts/#{user_account.to_param}"
    end

    # Al crear un user en el contexto de un tenant, automáticamente
    # se crea una UserAccount
    let!(:other_user) { create :user }
    let!(:user_account) { other_user.user_accounts.first }

    it do
      expect { subject }.to change(UserAccount.unscoped, :count).by(-1)
    end
  end
end

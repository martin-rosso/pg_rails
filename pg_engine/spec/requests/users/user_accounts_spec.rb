require 'rails_helper'

describe 'Devise invitable' do
  let(:logged_user) { create :user, :owner }

  # Al crear un user en el contexto de un tenant, automáticamente
  # se crea una UserAccount
  let!(:other_user) { create :user }
  let!(:user_account) { other_user.user_accounts.first }
  let(:tenant_id) do
    # FIXME: qué ondaa
    logged_user.current_user_account.to_param
  end

  before do
    sign_in logged_user
  end

  describe 'edit' do
    it do
      get "/u/user_accounts/#{user_account.to_param}/edit"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'update' do
    subject do
      params = {
        user_account: {
          profiles: ['cosas__read']
        }
      }
      patch "/u/user_accounts/#{user_account.to_param}", params:
    end

    it do
      expect { subject }.to(change { user_account.reload.profiles })
      expect(response).to redirect_to users_user_account_path(user_account, tenant_id:)
    end
  end

  describe 'destroy' do
    subject do
      delete "/u/user_accounts/#{user_account.to_param}"
    end

    it do
      expect { subject }.to change(UserAccount.unscoped, :count).by(-1)
    end
  end
end

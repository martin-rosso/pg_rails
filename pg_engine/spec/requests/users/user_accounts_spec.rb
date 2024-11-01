require 'rails_helper'

describe 'user accounts', :tpath_req do
  let!(:logged_user) { create :user, :owner }

  let(:account) { ActsAsTenant.current_tenant }
  let!(:user_account) { create :user_account, account: }

  before do
    sign_in logged_user
  end

  pending 'index'

  describe 'show' do
    it do
      get "/u/t/user_accounts/#{user_account.to_param}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'edit' do
    it do
      get "/u/t/user_accounts/#{user_account.to_param}/edit"
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
      patch "/u/t/user_accounts/#{user_account.to_param}", params:
    end

    it do
      expect { subject }.to(change { user_account.reload.profiles }.to(include('cosas__read')))
      expect(response).to redirect_to([:tenant, user_account])
    end
  end

  describe 'destroy' do
    subject do
      delete "/u/t/user_accounts/#{user_account.to_param}"
    end

    it do
      expect { subject }.to change(UserAccount.unscoped, :count).by(-1)
    end
  end
end

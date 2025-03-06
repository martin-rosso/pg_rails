require 'rails_helper'

describe 'user accounts', :tpath_req do
  let!(:logged_user) { create :user, :owner }

  let(:account) { ActsAsTenant.current_tenant }
  let!(:user_account) { create :user_account, account: }

  before do
    sign_in logged_user
  end

  describe '#index' do
    subject do
      get '/u/t/user_accounts'
    end

    it do
      subject
      expect(response).to have_http_status(:ok)
    end

    context 'when user is owner' do
      it 'shows the permissions' do
        subject
        expect(response.body).to have_text('Permisos')
      end
    end

    context 'when user is guest' do
      before do
        create :user, :owner
      end

      let!(:logged_user) { create :user, :guest }

      it 'when cant see the user list returns unauthorized' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'when can see user list dont shows the permissions' do
        logged_user.user_account_for(account).update(profiles: [:user_accounts__read])
        subject
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_no_text('Permisos')
      end
    end
  end

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
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

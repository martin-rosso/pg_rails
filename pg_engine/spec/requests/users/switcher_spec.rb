require 'rails_helper'

describe 'redirection' do
  let(:logged_user) { create :user }

  before do
    sign_in logged_user
  end

  context 'when switcher controller raises no tenant set' do
    # This is to prevent a redirect loop
    before do
      allow_any_instance_of(User).to receive(:user_accounts).and_raise(ActsAsTenant::Errors::NoTenantSet)
    end

    it 'shows the error' do
      get '/u/switcher'

      expect(response).to have_http_status(:internal_server_error)
    end
  end

  it do
    get '/u/cosas'

    expect(response).to have_http_status(:ok)
  end

  context 'when has been removed from account' do
    let!(:other_account) { create :account }
    let!(:other_user_account) { logged_user.user_accounts.create(account: other_account) }

    it 'redirects to switcher' do
      get '/u/cosas'
      expect(response).to redirect_to users_account_switcher_path
      follow_redirect!
      expect(response.body).to include 'Switcher'
      post "/u/switcher/#{other_user_account.to_param}"
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(response.body).to include other_account.to_s
      other_user_account.destroy!
      get '/'
      expect(response).to redirect_to users_account_switcher_path
    end
  end

  context 'when belongs to other account' do
    before do
      create :account, subdomain: 'other'
      host! 'other.example.com'
    end

    it do
      get '/u/cosas'

      expect(response).to redirect_to new_user_session_path
    end
  end
end

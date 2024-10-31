require 'rails_helper'

describe 'Users::AccountsController' do
  let(:account) { ActsAsTenant.current_tenant }
  let(:user) { create :user, :owner }

  before do
    sign_in user
    create_list :user, 2
  end

  it 'shows the owned account' do
    get "/u/cuentas/#{account.to_param}"
    expect(response).to have_http_status(:ok)
  end

  it 'denies foreign account' do
    other_account = create :account
    get "/u/cuentas/#{other_account.to_param}"
    expect(response).to have_http_status(:unauthorized)
  end

  describe 'index' do
    it do
      get '/u/cuentas'
      expect(response.body).to have_text('Mostrando 1 cuenta')
    end
  end

  describe 'create an account' do
    subject do
      post '/u/cuentas', params: {
        account: {
          plan: :completar,
          nombre: Faker::Lorem.sentence
        }
      }
    end

    it do
      expect { subject }.to change(Account, :count).by(1)
      expect(Account.last.owner).to eq user
    end
  end
end

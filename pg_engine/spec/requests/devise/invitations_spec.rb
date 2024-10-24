require 'rails_helper'

describe 'Devise invitable' do
  let(:logged_user) { create :user }

  before do
    sign_in logged_user
  end

  let(:account_id) { ActsAsTenant.current_tenant.hashid }

  it 'when theres no account_id' do
    get '/users/invitation/new'
    expect(response).to have_http_status(:bad_request)
  end

  it 'shows the form' do
    get '/users/invitation/new', params: { account_id: }
    expect(response).to have_http_status(:ok)
    expect(response.body).to have_text('Enviar Invitación')
  end

  describe 'create' do
    subject do
      post '/users/invitation', params: params
    end

    let(:params) do
      {
        user: {
          email: Faker::Internet.email,
          user_accounts_attributes: [{
            account_hashid:,
            profiles: [1]
          }]
        }
      }
    end

    it 'creates the user' do
      expect { subject }.to change(User.unscoped, :count).by(1).and(change(UserAccount.unscoped, :count).by(1))
    end
  end
end

require 'rails_helper'

describe 'Devise invitable' do
  let(:logged_user) { create :user }

  before do
    sign_in logged_user
  end

  it 'shows the form' do
    get '/users/invitation/new'
    expect(response).to have_http_status(:ok)
    expect(response.body).to have_text('Enviar Invitación')
  end

  describe 'create' do
    subject do
      post '/users/invitation', params: params
    end

    let(:email) { Faker::Internet.email }
    let(:params) do
      {
        user: {
          email:,
          user_accounts_attributes: [{
            profiles: ['administracion']
          }]
        }
      }
    end

    it 'creates the user' do
      expect { subject }.to change(User.unscoped, :count).by(1).and(change(UserAccount.unscoped, :count).by(1))
      expect(UserAccount.last.profiles).to match_array ['administracion']
    end

    context 'when the user exists' do
      let(:email) { logged_user.email }

      it do
        expect { subject }.not_to change(UserAccount.unscoped, :count)
      end
    end
  end
end

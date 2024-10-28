require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

describe 'Devise invitable' do
  describe 'send an invitation' do
    let(:logged_user) { create :user, :owner }

    before do
      sign_in logged_user
    end

    it 'shows the form' do
      get '/users/invitation/new'
      expect(response).to have_http_status(:ok)
      expect(response.body).to have_text('Agregar usuario')
    end

    describe 'create' do
      subject do
        post '/users/invitation', params:
      end

      let(:email) { Faker::Internet.email }
      let(:params) do
        {
          user: {
            email:,
            user_accounts_attributes: [{
              profiles: ['cosas__read']
            }]
          }
        }
      end

      it 'creates the user' do
        expect { subject }.to change(User.unscoped, :count).by(1).and(change(UserAccount.unscoped, :count).by(1))
        expect(UserAccount.last.profiles).to contain_exactly('cosas__read')
      end

      context 'when the user exists but not the user account' do
        let!(:other_user) do
          ActsAsTenant.without_tenant do
            create :user
          end
        end
        let(:email) { other_user.email }

        it do
          expect { subject }.to not_change(User.unscoped, :count).and(change(UserAccount.unscoped, :count).by(1))
        end
      end

      context 'when the user exists' do
        let(:email) { logged_user.email }

        it do
          expect { subject }.not_to change(UserAccount.unscoped, :count)
        end
      end
    end
  end

  describe 'accept an invitation' do
    subject do
      put '/users/invitation', params: {
        user: {
          nombre: Faker::Name.first_name,
          apellido: Faker::Name.last_name,
          password: 'asd12345',
          password_confirmation: 'asd12345',
          accept_terms: '1',
          invitation_token: user.raw_invitation_token
        }
      }
    end

    let(:user) do
      User.invite!({ email: Faker::Internet.email, user_accounts_attributes: [{ profiles: [] }] })
    end

    it do
      expect(user.user_accounts.length).to eq 1
      user_account = user.user_accounts.first
      expect(user_account.membership_status).to eq 'invited'
      expect { subject }.to change { user.reload.invitation_accepted_at }.to(be_present)
      put "/u/user_accounts/#{user_account.to_param}/accept_invitation"
      expect(user_account.reload.membership_status).to eq 'active'
    end

    context 'when accepting an invite' do
      subject do
        put "/u/user_accounts/#{user_account.to_param}/accept_invitation"
      end

      let(:logged_user) { create :user }
      let(:membership_status) { :invited }
      let(:user_account) do
        logged_user.user_accounts.first
      end

      before do
        sign_in logged_user
        user_account.update(membership_status:)
      end

      it do
        expect { subject }.to change { user_account.reload.membership_status }.to('active')
      end

      context 'and is not invited' do
        let(:membership_status) { :disabled }

        it do
          expect { subject }.not_to(change { user_account.reload.membership_status })
        end
      end
    end
  end
end

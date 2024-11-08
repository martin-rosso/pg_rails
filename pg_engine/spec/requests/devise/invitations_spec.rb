require 'rails_helper'

RSpec::Matchers.define_negated_matcher :not_change, :change

describe 'invite users to the platform and to an account #' do
  let(:account) { ActsAsTenant.current_tenant }

  describe 'send an invitation to the platform', :tpath_req do
    let(:logged_user) { create :user, :owner }

    before do
      sign_in logged_user
    end

    describe 'new' do
      it 'shows the form' do
        get '/users/invitation/new'
        expect(response).to have_http_status(:ok)
        expect(response.body).to have_text('Agregar usuario')
      end
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

      it 'creates the User and the UserAccount' do
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

        it 'creates the UserAccount but not the User' do
          expect { subject }.to not_change(User.unscoped, :count).and(change(UserAccount.unscoped, :count).by(1))
        end
      end

      context 'when the user exists but is discarded' do
        let!(:other_user) do
          ActsAsTenant.without_tenant do
            create :user, discarded_at: Time.current
          end
        end
        let(:email) { other_user.email }

        it 'doesnt create any' do
          expect { subject }.to not_change(User.unscoped, :count).and(not_change(UserAccount.unscoped, :count))
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'when the user belongs to the account' do
        let(:email) { logged_user.email }

        it 'doesnt create any' do
          expect { subject }.to not_change(User.unscoped, :count).and(not_change(UserAccount.unscoped, :count))
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'accept an invitation to the platform and to the account' do
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
      expect(user_account.invitation_status).to eq 'ist_invited'
      expect { subject }.to change { user.reload.invitation_accepted_at }.to(be_present)
      put "/u/espacios/#{account.to_param}/update_invitation", params: { accept: 1 }
      expect(user_account.reload.invitation_status).to eq 'ist_accepted'
    end
  end

  describe 'when updating an invitation' do
    let(:logged_user) { create :user, account: }
    let(:user_account) do
      logged_user.user_accounts.first
    end

    before do
      sign_in logged_user
      user_account.update(membership_status:, invitation_status: :ist_invited)
    end

    context 'accepting an invite' do
      subject do
        put "/u/espacios/#{account.to_param}/update_invitation", params: { accept: 1 }
      end

      let(:membership_status) { :ms_active }

      it do
        expect { subject }.to change { user_account.reload.invitation_status }.to('ist_accepted')
      end

      pending 'and doesnt belong to the account'
    end

    context 'when rejecting an invite' do
      subject do
        put "/u/espacios/#{account.to_param}/update_invitation", params: { reject: 1 }
      end

      let(:membership_status) { :ms_active }

      it do
        expect { subject }.to change { user_account.reload.invitation_status }.to('ist_rejected')
      end
    end

    context 'when signing off the account' do
      subject do
        put "/u/espacios/#{account.to_param}/update_invitation", params: { sign_off: 1 }
      end

      let(:membership_status) { %i[ms_active ms_disabled].sample }

      it do
        expect { subject }.to change { user_account.reload.invitation_status }.to('ist_signed_off')
      end
    end
  end

  describe 'remove an invitation', :tpath_req do
    subject do
      delete "/u/t/user_accounts/#{user_account.to_param}"
    end

    let(:logged_user) { create :user, :owner }
    let(:user_account) do
      user.user_accounts.first
    end
    let!(:user) do
      User.invite!({ email: Faker::Internet.email, user_accounts_attributes: [{ profiles: [] }] })
    end

    before do
      sign_in logged_user
    end

    context 'when the user is confirmed' do
      before do
        user.nombre = Faker::Name.first_name
        user.apellido = Faker::Name.last_name
        user.accept_invitation!
      end

      it 'removes the UserAccount but not the User' do
        expect { subject }.to change { UserAccount.unscoped.count }.by(-1).and(not_change(User.unscoped, :count))
      end
    end

    context 'when the user is not confirmed' do
      it 'removes both the UserAccount and the User' do
        expect { subject }.to change { UserAccount.unscoped.count }.by(-1).and(change(User.unscoped, :count).by(-1))
      end
    end
  end
end

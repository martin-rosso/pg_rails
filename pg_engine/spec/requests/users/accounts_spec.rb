require 'rails_helper'

describe 'Users::AccountsController' do
  let(:account) { ActsAsTenant.current_tenant }
  let(:user) { create :user, :owner }

  before do
    sign_in user
    create_list :user, 2
  end

  describe '#show' do
    it 'shows the owned account' do
      get "/u/espacios/#{account.to_param}"
      expect(response).to have_http_status(:ok)
    end

    it 'denies foreign account' do
      other_account = create :account
      get "/u/espacios/#{other_account.to_param}"
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when is guest user' do
      subject do
        get "/u/espacios/#{other_account.to_param}"
      end

      let(:other_account) { create :account }
      let(:membership_status) { :ms_active }
      let(:invitation_status) { :ist_accepted }
      let(:profiles) { [] }

      before do
        ActsAsTenant.with_tenant(other_account) do
          create :user, :owner
          create :user_account, user:, invitation_status:, membership_status:, profiles:
        end
      end

      context 'and has access to user list' do
        let(:profiles) { [:user_accounts__read] }

        it do
          subject
          expect(response.body).to include('embedded__user_accounts')
          expect(response.body).to have_text('Dejar el espacio')
        end
      end

      context 'when its active and dont have user_accounts__read access' do
        it do
          subject
          expect(response.body).not_to include('embedded__user_accounts')
          expect(response.body).to have_text('Dejar el espacio')
        end
      end

      context 'when its disabled' do
        let(:membership_status) { :ms_disabled }

        it do
          subject
          expect(response.body).to have_text('Deshabilitado')
          expect(response.body).to have_text('Dejar el espacio')
        end
      end

      context 'when its invited' do
        let(:invitation_status) { :ist_invited }

        it do
          subject
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe '#edit' do
    let(:nombre) { Faker::Lorem.sentence }

    it do
      get "/u/espacios/#{account.to_param}/edit"
      expect(response).to have_http_status(:ok)
      patch "/u/espacios/#{account.to_param}", params: { account: { nombre: } }
      expect(account.reload.nombre).to eq nombre
    end
  end

  describe 'index' do
    subject do
      get '/u/espacios'
    end

    before do
      other_account = create :account, :with_owner
      ActsAsTenant.without_tenant do
        create :user_account, account: other_account, user:, invitation_status:, membership_status:
      end
    end

    context 'cuando está invitado' do
      let(:invitation_status) { :ist_invited }
      let(:membership_status) { :ms_active }

      it do
        subject
        expect(response.body).to have_text('Aceptar invitación')
        expect(response.body).to have_text('Rechazar')
      end

      context 'y deshabilitado' do
        let(:membership_status) { :ms_disabled }

        it do
          subject
          expect(response.body).to have_no_text('Aceptar invitación')
        end
      end
    end
  end

  describe 'create an account' do
    subject do
      post '/u/espacios', params: {
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

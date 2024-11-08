require 'rails_helper'

describe 'redirection' do
  context 'when public controller raises no tenant set' do
    before do
      allow(MensajeContacto).to receive(:new).and_raise(ActsAsTenant::Errors::NoTenantSet)
    end

    it 'shows the error' do
      get '/contacto'

      expect(response).to have_http_status(:internal_server_error)
    end
  end

  context 'when logged in', :tpath_req do
    let(:logged_user) { create :user, :owner }

    before do
      sign_in logged_user
    end

    context 'when account is discarded' do
      it do
        get '/u/t/cosas'
        expect(response.body).to include 'No hay ningún coso que mostrar'
        logged_user.user_accounts.first.account.discard!
        get '/u/t/cosas'
        expect(response).to redirect_to users_accounts_path, tpath: false
      end
    end

    # TODO: activar subdomains
    # context 'when belongs to other account', pending: 'subdomains not ready' do
    #   before do
    #     create :account, subdomain: 'other'
    #     host! 'other.example.com'
    #   end

    #   it do
    #     get '/u/t/cosas'

    #     expect(response).to redirect_to new_user_session_path, tpath: false
    #   end
    # end
  end
end

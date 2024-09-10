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
end

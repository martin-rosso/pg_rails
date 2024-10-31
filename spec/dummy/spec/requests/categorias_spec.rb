require 'rails_helper'

describe 'category tenants', :tpath_req do
  let(:logged_user) { create :user, :owner }
  let(:other_account) { create :account }
  let(:categoria_de_cosa) { create :categoria_de_cosa }
  let!(:cosa) { create :cosa }

  before do
    sign_in logged_user
  end

  it 'shows not found if categoria_de_cosa not belongs to tenant' do
    ActsAsTenant.with_tenant(other_account) do
      categoria_de_cosa
    end

    get "/u/t/categoria_de_cosas/#{categoria_de_cosa.to_param}/cosas/#{cosa.to_param}"

    aggregate_failures do
      expect(response).to have_http_status(:not_found)
      expect(cosa.account).to eq ActsAsTenant.current_tenant
      expect(categoria_de_cosa.account).to eq other_account
    end
  end

  it do
    get '/u/t/categoria_de_cosas'
    expect(response).to have_http_status(:ok)
  end
end

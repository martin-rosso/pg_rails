require 'rails_helper'

describe 'Resources' do
  let(:user) { create :user }
  let(:cosa) { create :cosa }

  before do
    sign_in user
  end

  describe 'action links' do
    it 'shows the archive link' do
      get '/u/cosas/' + cosa.to_param
      expect(response).to have_http_status(:ok)
      regex = %r{<a data-turbo-method="post" .* href="/u/cosas/[\d]+/archive">}
      expect(response.body).to match regex
    end

    it 'shows the unarchive link' do
      cosa.update(discarded_at: Time.current)
      get '/u/cosas/' + cosa.to_param
      expect(response.body).to have_link(href: %r{/u/cosas/[\d]+/restore})
    end
  end

  describe 'set breadcrumbs for all actions' do
    it 'when flat archived index' do
      get '/u/cosas/archived'
      expect(response.body).to have_css('.breadcrumb a[href="/u/cosas"]')
    end

    it 'when nested archived index' do
      get "/u/categoria_de_cosas/#{cosa.categoria_de_cosa.to_param}/cosas/archived"
      expect(response.body).to \
        have_css ".breadcrumb a[href=\"/u/categoria_de_cosas/#{cosa.categoria_de_cosa.to_param}/cosas\"]"
    end
  end

  describe '#archive' do
    let(:url) { "/u/cosas/#{cosa.to_param}/archive" }

    it 'when accepts turbo stream' do
      headers = { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
      expect { post url, headers: }.to change { cosa.reload.discarded_at }.to(be_present)
      expect(response.body).to have_css('turbo-stream')
    end

    it 'when accepts only html' do
      expect { post url }.to change { cosa.reload.discarded_at }.to(be_present)
      expect(response).to redirect_to([:users, cosa])
    end

    context 'when fails' do
      before do
        allow_any_instance_of(Cosa).to receive(:discard).and_return(false)
      end

      it 'when accepts turbo stream' do
        post url, headers: { 'ACCEPT' => 'text/vnd.turbo-stream.html' }
        expect(response.body).to have_css('turbo-stream')
        expect(response.body).to include('Hubo un error al intentar actualizar el coso')
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'when accepts only html' do
        post url
        expect(response).to redirect_to([:users, cosa])
        expect(flash[:alert]).to eq 'Hubo un error al intentar actualizar el coso'
      end
    end
  end

  describe '#restore' do
    subject do
      post "/u/cosas/#{cosa.to_param}/restore"
    end

    let(:cosa) { create :cosa, discarded_at: Time.zone.now }

    it do
      expect { subject }.to change { cosa.reload.discarded_at }.to(be_nil)
    end
  end
end

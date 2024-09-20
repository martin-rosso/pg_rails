require 'rails_helper'

describe 'representations controller' do
  let(:file) { File.open("#{PgEngine::Engine.root}/spec/fixtures/test.pdf") }

  it do
    categoria = create :categoria_de_cosa
    categoria.file.attach(io: file, filename: 'test.pdf')
    path = polymorphic_url(categoria.file.preview(:thumb), only_path: true)
    expect(path).to start_with '/rails/active_storage/representations/redirect/'
    get path
    ActiveStorage::Current.url_options = { host: 'www.example.com' }
    expect(response).to have_http_status(:redirect)
    expect(response.headers['location']).to include '/rails/active_storage/disk/'
  end
end

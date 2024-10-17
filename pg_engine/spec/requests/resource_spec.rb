require 'rails_helper'

describe 'Resources' do
  let(:user) { create :user }

  before do
    sign_in user
  end

  describe 'action links' do
    let(:cosa) { create :cosa }

    it 'shows the archive link' do
      get '/u/cosas/' + cosa.to_param
      expect(response).to have_http_status(:ok)
      regex = %r{<a data-turbo-method="post" .* href="/u/cosas/1/archive">}
      expect(response.body).to match regex
    end
  end
end

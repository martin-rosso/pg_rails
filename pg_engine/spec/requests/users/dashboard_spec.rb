require 'rails_helper'

describe 'DASHBOARD', :tpath_req do
  let(:logged_user) { create :user }

  before do
    sign_in logged_user
  end

  it 'when requesting /u' do
    get '/u'
    expect(response.body).to include '<h1>Dashboard</h1>'
  end

  it 'when requesting /u/dashboard' do
    get '/u/dashboard'
    expect(response.body).to include '<h1>Dashboard</h1>'
  end
end

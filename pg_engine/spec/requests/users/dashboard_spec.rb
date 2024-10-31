require 'rails_helper'

describe 'DASHBOARD', :tpath_req do
  let(:logged_user) { create :user, :owner }

  before do
    sign_in logged_user
  end

  it 'when requesting /u/t/dashboard' do
    get '/u/t/dashboard'
    expect(response.body).to include '<h1>Dashboard</h1>'
  end
end

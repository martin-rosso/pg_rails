# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER & BROWSER environment variables to override, eg:
#
# DRIVER=selenium BROWSER=firefox rspec
describe '<%= name %>' do
  # include ActionView::RecordIdentifier

  subject(:visitar) do
    path = tpath("/u/t/some_tenanted_path", query_string: false)
    visit path
  end

  let(:logged_user) { create :user, :owner }
  # let(:account) { ActsAsTenant.current_tenant }

  before do
    login_as logged_user
  end

  describe 'some case' do
    it do
      visitar

      expect(page).to have_text 'some text'
    end
  end
end

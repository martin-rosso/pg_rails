# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe '<%= name %>' do
  subject(:visitar) do
    visit 'some url'
  end

  let(:logged_user) { create :user }
  let(:account) { ActsAsTenant.current_tenant }

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

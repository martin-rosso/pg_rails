# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Page sizes' do
  let(:logged_user) { create :user, :developer }

  before do
    login_as logged_user
    create_list :cosa, 8
  end

  describe 'some case' do
    it do
      visit '/admin/cosas?page_size=2'
      expect(page).to have_css('.page-item', count: 6)
      visit '/admin/cosas?page_size=5'
      expect(page).to have_css('.page-item', count: 4)
    end
  end
end

# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Breadcrumbs' do
  let(:cosa) { create :cosa }

  before do
    login_as create :user, :developer

    # just to sort a circumvent a capybara issue
    create_list :cosa, 1, categoria_de_cosa: cosa.categoria_de_cosa
  end

  describe 'some case' do
    it do
      visit "/a/cosas/#{cosa.id}"

      expect(page).to have_css('nav ol.breadcrumb li').exactly(3)
      expect(page).to have_css('nav ol.breadcrumb li a').exactly(1)
    end

    context 'cuando es con nested' do
      it do
        hashid = cosa.categoria_de_cosa.hashid
        visit "/a/categoria_de_cosas/#{hashid}/cosas/#{cosa.id}"

        expect(page).to have_css('nav ol.breadcrumb li').exactly(4)
        expect(page).to have_css('nav ol.breadcrumb li a').exactly(1)
      end
    end

    context 'cuando es con nested y modal' do
      it do
        visit "/a/categoria_de_cosas/#{cosa.categoria_de_cosa.hashid}"
        find_all('td span[title=Ver] a').first.click

        expect(page).to have_css('.modal nav ol.breadcrumb li').exactly(4)
        expect(page).to have_no_css('.modal nav ol.breadcrumb li a')
      end
    end
  end
end

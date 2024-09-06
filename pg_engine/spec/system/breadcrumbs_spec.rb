# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Breadcrumbs' do
  subject(:visitar) do
    visit path
  end

  let(:path) { "/a/cosas/#{cosa.id}" }
  let(:cosa) { create :cosa }
  let(:logged_user) { create :user, :developer }
  let(:account) { logged_user.current_account }

  before do
    login_as logged_user
  end

  describe 'some case' do
    it do
      visitar

      expect(page).to have_css('nav ol.breadcrumb li').exactly(3)
      expect(page).to have_css('nav ol.breadcrumb li a').exactly(1)
    end

    context 'cuando es con nested' do
      let(:path) do
        hashid = cosa.categoria_de_cosa.hashid
        "/a/categoria_de_cosas/#{hashid}/cosas/#{cosa.id}"
      end

      it do
        visitar

        expect(page).to have_css('nav ol.breadcrumb li').exactly(4)
        expect(page).to have_css('nav ol.breadcrumb li a').exactly(1)
      end
    end

    context 'cuando es con nested y modal' do
      let(:path) do
        hashid = cosa.categoria_de_cosa.hashid
        "/a/categoria_de_cosas/#{hashid}"
      end

      it do
        visitar
        find('td span[title=Ver] a').click

        expect(page).to have_css('.modal nav ol.breadcrumb li').exactly(4)
        expect(page).to have_no_css('.modal nav ol.breadcrumb li a')
      end
    end
  end
end

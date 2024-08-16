# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Date selector' do
  subject(:visitar) do
    visit edit_admin_categoria_de_cosa_path(categoria_de_cosa)
  end

  let(:logged_user) { create :user }
  let(:account) { logged_user.current_account }
  let(:categoria_de_cosa) { create :categoria_de_cosa, fecha: }
  let(:fecha) { Date.new(2024, 8, 12) }

  before do
    login_as logged_user
  end

  describe 'jump N days' do
    it do
      visitar
      find('.categoria_de_cosa_fecha .date-selector').click
      click_date_selector
      select 'Días hábiles'
      fill_in 'days', with: '3'
      click_on 'Aceptar'
      click_on 'Actualizar Categoría de cosa'
      expect(page).to have_text '15/8/2024'
    end
  end
end

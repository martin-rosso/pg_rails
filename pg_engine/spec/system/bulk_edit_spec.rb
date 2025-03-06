# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER & BROWSER environment variables to override, eg:
#
# DRIVER=selenium BROWSER=firefox rspec
describe 'Bulk edit' do
  subject(:visitar) do
    visit '/u/t/cosas'
  end

  let(:logged_user) { create :user, :owner }
  let(:account) { ActsAsTenant.current_tenant }

  before do
    login_as logged_user
    create_list :cosa, 2
  end

  describe 'bulk edit' do
    it do
      visitar
      page.find('[data-bs-title="Más opciones"]').click
      click_on 'Modificar masivamente'
      page.find('input[value=nombre]').click
      page.find_by_id('cosa_nombre').set('Nuevo valor')
      page.find('input[value=tipo]').click
      page.find_by_id('cosa_tipo').set('completar')
      click_on 'Confirmar'
      # expect(Cosa.pluck(:nombre)).to eq ["Nuevo valor", "Nuevo valor"]
      expect(page).to have_text 'Modificación en proceso'
    end
  end
end

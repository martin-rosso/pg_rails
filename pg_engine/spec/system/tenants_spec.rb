# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Tenants' do
  subject(:visitar) do
    visit '/u/t/cosas'
  end

  let(:logged_user) { create :user, :owner }

  before do
    login_as logged_user
  end

  describe 'account management' do
    it do
      visitar

      expect(page).to have_text 'No hay ningún coso que mostrar'
    end

    context 'when belongs to multiple accounts' do
      let(:other_account) { create :account }

      before do
        ActsAsTenant.with_tenant(other_account) do
          logged_user.user_accounts.create!(profiles: [:account__owner])
        end
        driven_by :selenium_chrome_headless_notebook
      end

      it 'shows the accounts index' do
        visitar

        expect(page).to have_text 'Mostrando un total de 2 espacios'
      end

      it 'switches to account' do
        visitar
        find_all('a', text: 'Ingresar').first.click
        # visit '/u/t/categoria_de_cosas'
        click_on 'Categorias front'
        expect(page).to have_text 'No hay ninguna categoría de cosa que mostrar'
      end

      it 'shows the profile form' do
        visit '/users/edit'

        expect(page).to have_text 'Editar Usuario'
      end
    end
  end
end

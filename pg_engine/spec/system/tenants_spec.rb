# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Tenants' do
  subject(:visitar) do
    visit '/u/cosas'
  end

  let(:logged_user) { create :user }

  before do
    login_as logged_user
  end

  describe 'switcher' do
    it do
      visitar

      expect(page).to have_text 'No hay cosos que mostrar'
    end

    context 'when belongs to multiple accounts' do
      let(:other_account) { create :account }

      before do
        logged_user.user_accounts.create!(account: other_account)
      end

      it 'shows the switcher' do
        visitar

        expect(page).to have_text 'Switcher'
      end

      it 'switches to account' do
        visitar

        click_on other_account.to_s
        visit '/u/categoria_de_cosas'
        expect(page).to have_text 'No hay categorías de cosas que mostrar'
      end

      it 'shows the profile form' do
        visit '/users/edit'

        expect(page).to have_text 'Editar Usuario'
      end
    end
  end
end

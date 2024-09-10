# Initially generated with PgRails::SystemSpecGenerator
# https://github.com/martin-rosso/pg_rails

require 'rails_helper'

# By default uses selenium_chrome_headless_iphone driver
# run with DRIVER environment variable to override, eg:
#
# DRIVER=selenium rspec
describe 'Modal windows' do
  subject(:visitar) do
    visit '/a/cosas'
  end

  let(:logged_user) { create :user, :developer }
  let!(:categoria_de_cosa) { create :categoria_de_cosa }

  before do
    login_as logged_user
  end

  describe 'crear con modal' do
    it do
      visitar
      click_on 'Cargar coso'
      select 'Completar', from: 'cosa_tipo'
      select categoria_de_cosa.to_s, from: 'cosa_categoria_de_cosa_id'
      find('.modal input[type=submit]').click
      expect(page).to have_text 'Por favor, revisá los campos obligatorios'
      fill_in 'cosa_nombre', with: 'bla'
      find('.modal input[type=submit]').click
      expect(page).to have_text 'bla'
    end
  end

  describe 'show con modal' do
    let!(:cosa) { create :cosa, categoria_de_cosa: }

    it do
      visit '/a/cosas/' + cosa.to_param
      click_on 'Ver categoría'
      expect(page).to have_css '.modal', text: categoria_de_cosa.nombre
    end
  end

  describe 'edit con modal' do
    let!(:cosa) { create :cosa, categoria_de_cosa: }

    it do
      visit '/a/cosas/' + cosa.to_param
      click_on 'Modificar'
      fill_in 'Nombre', with: ''
      find('.modal input[type=submit]').click
      expect(page).to have_text 'Por favor, revisá los campos obligatorios'
      fill_in 'Nombre', with: 'bla'
      find('.modal input[type=submit]').click
      expect(page).to have_text 'bla'
    end
  end

  describe 'destroy con modal' do
    before { create :cosa, categoria_de_cosa: }

    it do
      visit '/a/cosas'
      find('span[title=Ver] a').click
      accept_confirm do
        find('.modal span[title=Eliminar] a').click
      end
      expect(page).to have_text 'No hay cosos que mostrar'
    end

    context 'cuando da error' do
      before do
        allow_any_instance_of(Cosa).to receive(:discard).and_return(false)
      end

      it do
        visit '/a/cosas'
        find('span[title=Ver] a').click
        accept_confirm do
          find('.modal span[title=Eliminar] a').click
        end
        expect(page).to have_text 'No se pudo eliminar el registro'
      end
    end
  end
end

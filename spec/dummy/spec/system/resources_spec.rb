require 'rails_helper'

describe 'Resources' do
  let(:user) { create :user, :developer }

  before do
    login_as user
  end

  describe 'show modal' do
    let!(:cosa) { create :cosa }

    it do
      visit "/a/cosas/#{cosa.id}"
      click_on 'Ver categoría'
      expect(page.find('.modal')).to have_text 'Fade in'
    end
  end

  describe 'i18n' do
    before do
      create :categoria_de_cosa
    end

    it do
      visit '/a/categoria_de_cosas?mostrar_filtros=1'
      expect(page.find('input[placeholder="Tipo filter default"]')).to be_present
      expect(page.find('.listado')).to have_text 'Tipo header'
    end
  end
end

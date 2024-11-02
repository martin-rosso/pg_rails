require 'rails_helper'

describe 'Associable' do
  let(:user) { create :user, :owner }

  let(:path) { '/u/t/cosas/new' }

  before do
    login_as user
    visit path
  end

  fit do
    fill_in 'cosa_nombre', with: 'La cosa'
    select 'Los', from: 'cosa_tipo'
    find('.cosa_categoria_de_cosa input[type=text]').click
    expect(page).to have_text :all, 'Nueva categoría de cosa'
    find('.cosa_categoria_de_cosa .list-group-item').click
    # select Account.first.to_s
    fill_in 'categoria_de_cosa_nombre', with: 'la categoría'
    select 'Completar', from: 'categoria_de_cosa_tipo'
    click_on 'Agregar Categoría de cosa'
    click_on 'Cargar Coso'
    expect(page).to have_text 'La cosa'
  end

  context 'cuando crea desde el nested' do
    let!(:categ) { create :categoria_de_cosa }
    let(:path) { "/u/t/categoria_de_cosas/#{categ.hashid}/cosas/new" }

    it do
      input = find_by_id('cosa_categoria_de_cosa')
      expect(input).to be_disabled
    end
  end

  context 'cuando edita desde el nested' do
    let!(:categ) { create :categoria_de_cosa }
    let!(:cosa) { create :cosa, categoria_de_cosa: categ }
    let(:path) { "/u/t/categoria_de_cosas/#{categ.hashid}/cosas/#{cosa.id}/edit" }

    it do
      ele = find_by_id('cosa_categoria_de_cosa_id', visible: :all)
      input = ele.sibling('input[type=text]')
      expect(input).not_to be_disabled
    end
  end
end

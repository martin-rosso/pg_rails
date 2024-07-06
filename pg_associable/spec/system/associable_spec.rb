require 'rails_helper'

describe 'Associable' do
  let(:user) { create :user, :developer }

  before do
    login_as user
    driven_by :selenium
    visit '/admin/cosas/new'
    fill_in 'cosa_nombre', with: 'La cosa'
    select 'Los', from: 'cosa_tipo'
    find('.cosa_categoria_de_cosa input[type=text]').click
  end

  it do
    expect(page).to have_text :all, 'Nuevo'
    find('.cosa_categoria_de_cosa .list-group-item').click
    fill_in 'categoria_de_cosa_nombre', with: 'la categoría'
    select 'Completar', from: 'categoria_de_cosa_tipo'
    click_on 'Crear Categoría de cosa'
    click_on 'Crear Coso'
    expect(page).to have_text 'Creado por'
  end
end

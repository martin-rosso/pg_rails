require 'rails_helper'

describe 'Filtros de cosas' do
  subject(:buscar) do
    click_on 'Buscar'
  end

  let(:visitar) do
    visit path
  end
  let(:user) { create :user, :owner }
  let(:listado) { page.find('.listado') }
  let!(:search_fields) { nil }

  before do
    if search_fields.present?
      allow_any_instance_of(controller_class).to \
        receive(:atributos_para_buscar).and_return(
          search_fields
        )
    end
    login_as user
  end

  describe 'Cosas' do
    let!(:cosa) { create :cosa, nombre: }
    let(:nombre) { Faker::Lorem.sentence }
    let!(:otro_tipo) { Cosa.tipo.values.reject { _1 == cosa.tipo }.sample }
    let!(:otra_cosa) { create :cosa, tipo: otro_tipo }
    let(:controller_class) { Tenant::CosasController }
    let(:path) { '/u/t/cosas' }

    describe 'default sort' do
      before do
        create :cosa, nombre: 'AAA'
        create :cosa, nombre: 'BBB'
        create :cosa, nombre: 'CCC'
        create :cosa, nombre: 'DDD'
      end

      it do
        visitar
        target = page.find('.listado').native.attribute('outerHTML')
        expect(target).to match(/AAA.*BBB.*CCC.*DDD/)
      end
    end

    context 'buscar por nombre sin predicado' do
      let(:search_fields) { %i[nombre] }

      it do
        visitar
        fill_in 'Nombre', with: 'asd'
        buscar
        expect(page).to have_text 'No hay ningún coso para los filtros aplicados'
      end
    end

    context 'buscar por nombre not_cont' do
      let(:search_fields) { %i[nombre_not_cont] }
      let(:nombre) { 'uno dos tres' }

      it do
        visitar
        fill_in 'Nombre no contiene', with: 'dos'
        buscar
        expect(listado).to have_text otra_cosa.nombre
        expect(listado).to have_no_text cosa.nombre
      end
    end

    context 'buscar por nombre cont_any' do
      let(:search_fields) { %i[nombre_cont_any] }
      let(:nombre) { 'uno dos tres' }

      it do
        visitar
        fill_in 'Nombre', with: 'dos bla'
        buscar
        expect(listado).to have_text nombre
      end
    end

    context 'buscar categoría por select simple' do
      shared_examples 'buscar select simple' do
        it do
          visitar
          expect(listado).to have_text otra_cosa.categoria_de_cosa.to_s
          select(cosa.categoria_de_cosa.to_s)
          buscar
          expect(listado).to have_text cosa.categoria_de_cosa.to_s
          expect(listado).to have_no_text otra_cosa.categoria_de_cosa.to_s
        end
      end

      context 'cuando es con _id' do
        let(:search_fields) { %i[categoria_de_cosa_id] }

        it_behaves_like 'buscar select simple'
      end

      context 'cuando es sin id' do
        let(:search_fields) { %i[categoria_de_cosa] }

        it_behaves_like 'buscar select simple'
      end
    end

    context 'buscar categoría por select múltiple' do
      let(:search_fields) { %i[categoria_de_cosa_id_in] }

      it do
        visitar
        expect(listado).to have_text otra_cosa.categoria_de_cosa.to_s
        select_tom(placeholder: 'Categoria de cosa', text: cosa.categoria_de_cosa.to_s)
        buscar
        expect(listado).to have_text cosa.categoria_de_cosa.to_s
        expect(listado).to have_no_text otra_cosa.categoria_de_cosa.to_s
      end
    end

    context 'buscar tipo por select simple' do
      let(:search_fields) { %i[tipo] }

      it do
        visitar
        expect(listado).to have_text otra_cosa.tipo_text
        select(cosa.tipo_text)
        buscar
        expect(listado).to have_text cosa.tipo_text
        expect(listado).to have_no_text otra_cosa.tipo_text
      end

      context 'cuando hay options enum values' do
        let(:path) { tpath('/u/t/cosas?custom_options=enum_values', query_string: false) }

        it do
          visitar
          expect(page).to have_css('option', text: 'Completar')
          expect(page).to have_no_css('option', text: 'Valores')
        end
      end

      context 'cuando hay options hash' do
        let(:path) { tpath('/u/t/cosas?custom_options=hash', query_string: false) }

        it do
          visitar
          expect(page).to have_css('option', text: 'Uno')
          expect(page).to have_css('option', text: 'Dos')
          expect(page).to have_no_css('option', text: 'Completar')
        end
      end
    end

    context 'buscar tipo por select múltiple' do
      let(:search_fields) { %i[tipo_in] }

      it do
        visitar
        expect(listado).to have_text otra_cosa.tipo_text
        select_tom(placeholder: 'Tipo', text: cosa.tipo_text)
        buscar
        expect(listado).to have_text cosa.tipo_text
        expect(listado).to have_no_text otra_cosa.tipo_text
      end
    end
  end

  describe 'Categorías' do
    let(:controller_class) { Tenant::CategoriaDeCosasController }
    let(:path) { '/u/t/categoria_de_cosas' }
    let(:search_fields) { %i[fecha] }

    let!(:categoria) { create :categoria_de_cosa }
    let(:otra_fecha) { categoria.fecha + 1.day }
    let!(:otra_categoria) { create :categoria_de_cosa, fecha: otra_fecha }

    describe 'fechas' do
      it do
        visitar
        expect(listado).to have_text otra_categoria.decorate.nombre_f
        fill_in 'Fecha desde', with: categoria.fecha
        fill_in 'Fecha hasta', with: categoria.fecha
        buscar
        expect(listado).to have_text categoria.decorate.nombre_f
        expect(listado).to have_no_text otra_categoria.decorate.nombre_f
      end
    end

    describe 'ocultar filtros' do
      it do
        visitar
        expect(page).to have_css 'button .bi-search'
        find("[data-bs-title='Más opciones'] button").click
        click_on 'Ocultar filtros'
        expect(page).to have_no_css 'button .bi-search'
      end
    end

    describe 'sorting' do
      it do
        visitar
        anterior = categoria.decorate.fecha
        posterior = otra_categoria.decorate.fecha
        click_on 'Fecha'
        target = page.find('.listado').native.attribute('outerHTML')
        expect(target).to match(/#{posterior}.*#{anterior}/)
        click_on 'Fecha'
        target = page.find('.listado').native.attribute('outerHTML')
        expect(target).to match(/#{anterior}.*#{posterior}/)
      end
    end
  end

  describe 'Users' do
    let(:controller_class) { Admin::UsersController }
    let(:path) { '/a/users' }
    let(:search_fields) { %i[developer] }

    let!(:target_user) { create :user, :orphan, developer: true }
    let!(:otro_user) { create :user, :orphan, developer: false }
    let(:user) { create :user, :developer }

    describe 'boolean' do
      it do
        visitar
        expect(listado).to have_text otro_user.email
        select 'Sí'
        buscar
        expect(listado).to have_text target_user.email
        expect(listado).to have_no_text otro_user.email
      end
    end
  end
end

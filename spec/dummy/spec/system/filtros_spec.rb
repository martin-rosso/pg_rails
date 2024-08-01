require 'rails_helper'

describe 'Filtros de cosas' do
  subject(:buscar) do
    click_on 'Buscar'
  end

  let(:visitar) do
    visit path
    click_on 'Filtrar'
  end
  let(:user) { create :user, :developer }
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
    let!(:cosa) { create :cosa }
    let!(:otro_tipo) { Cosa.tipo.values.reject { _1 == cosa.tipo }.sample }
    let!(:otra_cosa) { create :cosa, tipo: otro_tipo }
    let(:controller_class) { Admin::CosasController }
    let(:path) { '/admin/cosas' }

    it 'buscar por nombre' do
      visitar
      fill_in 'Nombre', with: 'asd'
      buscar
      expect(page).to have_text 'No hay cosos para los filtros aplicados'
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

        include_examples 'buscar select simple'
      end

      context 'cuando es sin id' do
        let(:search_fields) { %i[categoria_de_cosa] }

        include_examples 'buscar select simple'
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
    let(:controller_class) { Admin::CategoriaDeCosasController }
    let(:path) { '/admin/categoria_de_cosas' }
    let(:search_fields) { %i[fecha] }

    let!(:categoria) { create :categoria_de_cosa }
    let(:otra_fecha) { categoria.fecha + 1.day }
    let!(:otra_categoria) { create :categoria_de_cosa, fecha: otra_fecha }

    it do
      visitar
      expect(listado).to have_text otra_categoria.nombre
      fill_in 'Fecha desde', with: categoria.fecha
      fill_in 'Fecha hasta', with: categoria.fecha
      buscar
      expect(listado).to have_text categoria.nombre
      expect(listado).to have_no_text otra_categoria.nombre
    end
  end
end

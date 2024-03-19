require 'rails_helper'

describe PgEngine::Resource do
  let(:instancia) { Admin::CategoriaDeCosasController.new }

  describe '#buscar_instancia' do
    subject do
      instancia.send(:buscar_instancia)
    end

    let!(:categoria_de_cosa) { create :categoria_de_cosa }
    let(:request) { double }

    before do
      CategoriaDeCosa.stub(:find_by_hashid!)
      allow(request).to receive_messages(filtered_parameters: { id: categoria_de_cosa.to_param },
                                         parameters: { id: categoria_de_cosa.to_param })
      allow(instancia).to receive(:request).and_return(request)
      instancia.set_clase_modelo
    end

    it do
      subject
      expect(CategoriaDeCosa).to have_received(:find_by_hashid!)
    end

    it do
      expect(subject).to eq categoria_de_cosa
    end
  end

  describe '#do_sort' do
    subject do
      instancia.send(:do_sort, scope, param, direction)
    end

    let!(:categoria_de_cosa_ult) { create :categoria_de_cosa, nombre: 'Z' }
    let!(:categoria_de_cosa_pri) { create :categoria_de_cosa, nombre: 'a' }
    let(:scope) { CategoriaDeCosa.all }
    let(:param) { :nombre }
    let(:direction) { :desc }

    context 'asc' do
      let(:direction) { :asc }

      it do
        expect(subject.to_a).to eq [categoria_de_cosa_pri, categoria_de_cosa_ult]
      end
    end

    context 'desc' do
      let(:direction) { :desc }

      it do
        expect(subject.to_a).to eq [categoria_de_cosa_ult, categoria_de_cosa_pri]
      end
    end

    context 'cuando no existe el param' do
      let(:param) { :inexistente }

      it do
        expect(subject.to_a).to eq [categoria_de_cosa_ult, categoria_de_cosa_pri]
      end
    end
  end
end

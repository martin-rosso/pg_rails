require 'rails_helper'

describe PgEngine::Resource do
  let(:instancia) { Admin::CategoriaDeCosasController.new }

  describe '#buscar_instancia cuando no existe el record' do
    subject do
      instancia.send(:buscar_instancia)
    end

    let(:request) { double }

    before do
      allow(request).to receive_messages(filtered_parameters: { id: 321 },
                                         parameters: { id: 321 })
      allow(instancia).to receive(:request).and_return(request)
    end

    it do
      expect { subject }.to raise_error(PgEngine::PageNotFoundError)
    end
  end

  describe '#buscar_instancia' do
    subject do
      instancia.send(:buscar_instancia)
    end

    let!(:categoria_de_cosa) { create :categoria_de_cosa }
    let(:request) { double }

    before do
      allow(request).to receive_messages(filtered_parameters: { id: categoria_de_cosa.to_param },
                                         parameters: { id: categoria_de_cosa.to_param })
      allow(instancia).to receive(:request).and_return(request)
    end

    it do
      allow(CategoriaDeCosa).to receive(:find_by_hashid!)
      subject
      expect(CategoriaDeCosa).to have_received(:find_by_hashid!)
    end

    it do
      expect(subject).to eq categoria_de_cosa
    end
  end
end

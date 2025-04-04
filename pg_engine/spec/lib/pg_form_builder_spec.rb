require 'rails_helper'

describe PgFormBuilder do
  let(:categoria) { create :categoria_de_cosa }
  let(:template) do
    klass = Class.new
    klass.include ActionView::Helpers::TagHelper
    klass.new
  end

  let(:instancia) { described_class.new('bla', categoria, template, {}) }

  before { create_list :cosa, 2, categoria_de_cosa: categoria }

  describe '#mensajes_de_error' do
    subject { instancia.mensajes_de_error }

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.nombre = nil
        categoria.validate
      end

      it { expect(subject).to include 'Por favor, revisá los campos obligatorios:' }
    end

    context 'cuando solo tiene errores de :base' do
      before do
        categoria.validate_base = true
        categoria.validate
      end

      it { expect(subject).to include 'Por favor, revisá los siguientes errores' }
    end
  end

  describe '#mensaje' do
    subject { instancia.mensaje }

    context 'cuando solo tiene errores de presencia' do
      before do
        categoria.nombre = nil
        categoria.validate
      end

      it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }
    end

    context 'cuando solo tiene errores de presencia en nested' do
      before do
        categoria.reload
        categoria.cosas[0].nombre = nil
        categoria.validate
      end

      it { expect(subject).to eq 'Por favor, revisá los campos obligatorios:' }
    end
  end

  describe '#default_prefix' do
    context 'cuando el atributo es masculino' do
      subject { instancia.default_prefix(:nombre) }

      it { expect(subject).to eq 'El nombre' }
    end

    context 'cuando el atributo es femenino' do
      subject { instancia.default_prefix(:fecha) }

      it { expect(subject).to eq 'La fecha' }
    end
  end

  describe '#collection_pc' do
    subject do
      Current.namespace = :tenant

      instancia.collection_pc(:creado_por, {})
    end

    context 'when user is foreign' do
      let!(:user) { create :user }

      context 'when category has not an actual value' do
        let(:categoria) { create :categoria_de_cosa, creado_por: nil }

        it do
          expect(subject[0]).to eq []
        end
      end

      context 'when category has an actual value' do
        let(:categoria) { create :categoria_de_cosa, creado_por: user }

        it 'doent show even when it is the actual value' do
          expect(categoria.reload.creado_por).to eq user
          expect(subject[0]).to eq []
        end
      end
    end

    context 'when its active' do
      let!(:user) { create :user, :guest }

      context 'when category has not an actual value' do
        let(:categoria) { create :categoria_de_cosa, creado_por: nil }

        it do
          expect(subject[0]).to eq [user]
        end
      end

      context 'when category has an actual value' do
        let(:categoria) { create :categoria_de_cosa, creado_por: user }

        it do
          expect(subject[0]).to include user
        end
      end
    end

    context 'when its disabled' do
      let!(:user) { create :user, :guest, :disabled }

      context 'when category has not an actual value' do
        let(:categoria) { create :categoria_de_cosa, creado_por: nil }

        it do
          expect(subject[0]).to eq []
        end
      end

      context 'when category has an actual value' do
        let(:categoria) { create :categoria_de_cosa, creado_por: user }

        it do
          expect(subject[0]).to include user
        end
      end
    end
  end
end

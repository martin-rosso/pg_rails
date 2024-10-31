require 'rails_helper'

describe PgAssociable::Helpers do
  include ActiveSupport::CurrentAttributes::TestHelper

  before do
    Current.namespace = :admin
  end

  # DEPRECATED
  describe '#pg_respond_buscar with query scope' do
    let(:ctrl) do
      Admin::CategoriaDeCosasController.new
    end
    let!(:categoria_de_cosa) { create :categoria_de_cosa }
    let(:tid) do
      Current.user.user_account_for(Current.account).to_param
    end

    before do
      Current.user = create :user, :owner
      allow(ctrl).to receive_messages(params: { id: 123, query: categoria_de_cosa.nombre, tid: })
      allow(ctrl).to receive(:render)
    end

    it do
      ctrl.pg_respond_buscar
      categoria_de_cosas = ctrl.instance_variable_get(:@collection)
      expect(categoria_de_cosas).to eq [categoria_de_cosa]
    end
  end

  describe '#pg_respond_buscar with id' do
    let(:ctrl) do
      Admin::CosasController.new
    end
    let!(:cosa) { create :cosa }

    before do
      Current.user = create :user, :owner
      allow(ctrl).to receive_messages(params: { id: 123, query: cosa.id })
      allow(ctrl).to receive(:render)
    end

    it do
      ctrl.pg_respond_buscar
      cosas = ctrl.instance_variable_get(:@collection)
      expect(cosas).to eq [cosa]
    end
  end

  describe '#pg_respond_buscar with ransack' do
    let(:ctrl) do
      Admin::AccountsController.new
    end
    let!(:account) { create :account }

    before do
      Current.user = create :user, :developer
      allow(ctrl).to receive_messages(params: { id: 123, query: account.nombre })
      allow(ctrl).to receive(:render)
    end

    it do
      ctrl.pg_respond_buscar
      accounts = ctrl.instance_variable_get(:@collection)
      expect(accounts).to eq [account]
    end
  end
end

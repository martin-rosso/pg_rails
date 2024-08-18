require 'rails_helper'

RSpec::Matchers.define :include_modal_hidden_input do
  match do |actual|
    actual.include?('<input type="hidden" name="modal" id="modal" value="true"')
  end
end

describe PgEngine::FormHelper do
  subject do
    view_context.pg_form_for(cosa, **options) do |f|
      f.submit 'ACEPTAR'
    end
  end

  let(:options) do
    { modal: }
  end

  let(:modal) { false }

  let(:view_context) do
    cont = Admin::CosasController.new
    cont.request = ActionDispatch::TestRequest.create
    cont.view_context
  end
  let(:cosa) { Cosa.new }

  before do
    Current.namespace = :admin
  end

  it 'renders the form and the button' do
    expect(subject).to include 'ACEPTAR'
    expect(subject).to include '<form'
  end

  context 'when rendering modal' do
    let(:modal) { true }

    it 'renders the modal hidden input' do
      expect(subject).to include_modal_hidden_input
    end
  end

  context 'when not rendering modal' do
    let(:modal) { false }

    it do
      expect(subject).not_to include_modal_hidden_input
    end
  end

  context 'when there are errors' do
    let(:cosa) do
      ret = Cosa.new(nombre: nil)
      ret.validate
      ret
    end

    it 'renders the errors' do
      expect(subject).to include 'Por favor, revisá los campos obligatorios'
    end

    context 'and its requested not to render errors' do
      let(:options) do
        { render_errors: false }
      end

      it 'renders the errors' do
        expect(subject).not_to include 'Por favor, revisá los campos obligatorios'
      end
    end
  end
end

require 'rails_helper'

describe PgEngine::FormHelper do
  subject do
    view_context.pg_form_for(cosa, **options) do |f|
      f.submit 'ACEPTAR'
    end
  end

  let(:options) do
    {}
  end

  let(:using_modal) { false }

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

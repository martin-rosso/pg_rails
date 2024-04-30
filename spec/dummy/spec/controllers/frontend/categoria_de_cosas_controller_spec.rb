# frozen_string_literal: true

# generado con pg_rails

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Frontend::CategoriaDeCosasController do
  render_views
  # This should return the minimal set of attributes required to create a valid
  # CategoriaDeCosa. As you add validations to CategoriaDeCosa, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:categoria_de_cosa)
  end

  let(:invalid_attributes) do
    {
      nombre: nil
    }
  end

  let(:user) { create :user, :admin }

  before do
    sign_in user if user.present?
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    let(:categoria_de_cosa) { create :categoria_de_cosa }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      let(:user) { nil }

      it 'redirects to login path' do
        subject
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when está descartado' do
      before { categoria_de_cosa.discard! }

      it do
        subject
        expect(assigns(:collection)).to be_empty
      end
    end

    context 'when se pide el excel' do
      subject do
        get :index, params: {}, format: 'xlsx'
      end

      it 'returns a success response' do
        subject
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      categoria_de_cosa = create(:categoria_de_cosa)
      get :show, params: { id: categoria_de_cosa.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      categoria_de_cosa = create(:categoria_de_cosa)
      get :edit, params: { id: categoria_de_cosa.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new CategoriaDeCosa' do
        expect do
          post :create, params: { categoria_de_cosa: valid_attributes }
        end.to change(CategoriaDeCosa, :count).by(1)
      end

      it 'redirects to the created categoria_de_cosa' do
        post :create, params: { categoria_de_cosa: valid_attributes }
        expect(response).to redirect_to(CategoriaDeCosa.last.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        post :create, params: { categoria_de_cosa: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post :create, params: { categoria_de_cosa: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:categoria_de_cosa)
      end

      it 'updates the requested categoria_de_cosa' do
        categoria_de_cosa = create(:categoria_de_cosa)
        put :update, params: { id: categoria_de_cosa.to_param, categoria_de_cosa: new_attributes }
        categoria_de_cosa.reload
        expect(categoria_de_cosa.nombre).to eq new_attributes[:nombre]
      end

      it 'redirects to the categoria_de_cosa' do
        categoria_de_cosa = create(:categoria_de_cosa)
        put :update, params: { id: categoria_de_cosa.to_param, categoria_de_cosa: valid_attributes }
        expect(response).to redirect_to(categoria_de_cosa.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        categoria_de_cosa = create(:categoria_de_cosa)
        put :update, params: { id: categoria_de_cosa.to_param, categoria_de_cosa: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        categoria_de_cosa = create(:categoria_de_cosa)
        put :update, params: { id: categoria_de_cosa.to_param, categoria_de_cosa: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      request.headers["Accept"] = "text/vnd.turbo-stream.html,text/html"
      delete :destroy, params: { id: categoria_de_cosa.to_param, redirect_to: redirect_url }
    end

    let!(:categoria_de_cosa) { create :categoria_de_cosa }
    let(:redirect_url) { nil }

    it 'destroys the requested categoria_de_cosa' do
      expect { subject }.to change(CategoriaDeCosa.kept, :count).by(-1)
    end

    it 'setea el discarded_at' do
      subject
      expect(categoria_de_cosa.reload.discarded_at).to be_present
    end

    it 'quita el elemento de la lista' do
      subject
      expect(response.body).to include('turbo-stream action="remove"')
    end

    context 'si hay redirect_to' do
      let(:redirect_url) { frontend_categoria_de_cosas_url }

      it 'redirects to the categoria_de_cosas list' do
        subject
        expect(response).to redirect_to(frontend_categoria_de_cosas_url)
      end
    end
  end
end

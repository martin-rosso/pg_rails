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

RSpec.describe Admin::CosasController do
  render_views
  let(:categoria_de_cosa) { create :categoria_de_cosa }

  # This should return the minimal set of attributes required to create a valid
  # Cosa. As you add validations to Cosa, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:cosa).merge(categoria_de_cosa_id: categoria_de_cosa.id, account_id: ActsAsTenant.current_tenant.id)
  end

  let(:invalid_attributes) do
    {
      nombre: nil
    }
  end

  let(:user) { create :user, :developer }

  before do
    sign_in user if user.present?
  end

  describe 'routing' do
    it 'routes GET index correctly' do
      route = { get: '/a/cosas' }
      expect(route).to route_to(controller: 'admin/cosas', action: 'index')
    end
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    let!(:cosa) { create :cosa }

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
      before { cosa.discard! }

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
      cosa = create(:cosa)
      get :show, params: { id: cosa.to_param }
      expect(response).to be_successful
    end

    it 'cuando no existe el record' do
      get :show, params: { id: 321 }
      expect(response).to have_http_status(:not_found)
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
      cosa = create(:cosa)
      get :edit, params: { id: cosa.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Cosa' do
        expect do
          post :create, params: { cosa: valid_attributes }
        end.to change(Cosa, :count).by(1)
      end

      it 'redirects to the created cosa' do
        post :create, params: { cosa: valid_attributes }
        expect(response).to redirect_to([:admin, Cosa.last])
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        post :create, params: { cosa: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post :create, params: { cosa: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:cosa)
      end

      it 'updates the requested cosa' do
        cosa = create(:cosa)
        put :update, params: { id: cosa.to_param, cosa: new_attributes }
        cosa.reload
        expect(cosa.nombre).to eq new_attributes[:nombre]
      end

      it 'redirects to the cosa' do
        cosa = create(:cosa)
        put :update, params: { id: cosa.to_param, cosa: valid_attributes }
        expect(response).to redirect_to([:admin, cosa])
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        cosa = create(:cosa)
        put :update, params: { id: cosa.to_param, cosa: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        cosa = create(:cosa)
        put :update, params: { id: cosa.to_param, cosa: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      request.headers['Accept'] = 'text/vnd.turbo-stream.html,text/html'
      delete :destroy, params: { id: cosa.to_param, land_on: }
    end

    let!(:cosa) { create :cosa }
    let(:land_on) { nil }

    it 'destroys the requested cosa' do
      expect { subject }.to change(Cosa.kept, :count).by(-1)
    end

    it 'envía el pg-event' do
      subject
      expect(response.body).to include('<pg-event data-event-name="pg:record-destroyed"')
    end

    context 'si hay land_on' do
      let(:land_on) { :index }

      it 'redirects to the cosas list' do
        subject
        expect(response).to redirect_to(admin_cosas_url)
      end
    end
  end
end

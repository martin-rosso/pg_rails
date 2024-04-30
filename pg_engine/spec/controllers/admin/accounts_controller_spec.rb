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

RSpec.describe Admin::AccountsController do
  render_views
  # This should return the minimal set of attributes required to create a valid
  # Account. As you add validations to Account, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:account)
  end

  let(:invalid_attributes) do
    {
      plan: nil
    }
  end

  let(:user) { create :user, :admin }

  before do
    sign_in user if user.present?
  end

  describe 'routing' do
    it 'routes GET index correctly' do
      route = { get: '/a/accounts' }
      expect(route).to route_to(controller: 'admin/accounts', action: 'index')
    end
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    let!(:account) { create :account }

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
      before { account.discard! }

      it do
        subject
        expect(assigns(:collection)).not_to include(account)
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
      account = create(:account)
      get :show, params: { id: account.to_param }
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
      account = create(:account)
      get :edit, params: { id: account.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Account' do
        expect do
          post :create, params: { account: valid_attributes }
        end.to change(Account, :count).by(1)
      end

      it 'redirects to the created account' do
        post :create, params: { account: valid_attributes }
        expect(response).to redirect_to(Account.last.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        post :create, params: { account: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post :create, params: { account: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:account)
      end

      it 'updates the requested account' do
        account = create(:account)
        put :update, params: { id: account.to_param, account: new_attributes }
        account.reload
        expect(account.plan).to eq new_attributes[:plan]
      end

      it 'redirects to the account' do
        account = create(:account)
        put :update, params: { id: account.to_param, account: valid_attributes }
        expect(response).to redirect_to(account.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        account = create(:account)
        put :update, params: { id: account.to_param, account: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        account = create(:account)
        put :update, params: { id: account.to_param, account: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      request.headers["Accept"] = "text/vnd.turbo-stream.html,text/html"
      delete :destroy, params: { id: account.to_param, redirect_to: redirect_url }
    end

    let!(:account) { create :account }
    let(:redirect_url) { nil }

    it 'destroys the requested account' do
      expect { subject }.to change(Account.kept, :count).by(-1)
    end

    it 'setea el discarded_at' do
      subject
      expect(account.reload.discarded_at).to be_present
    end

    it 'quita el elemento de la lista' do
      subject
      expect(response.body).to include('turbo-stream action="remove"')
    end

    context 'si hay redirect_to' do
      let(:redirect_url) { admin_accounts_url }

      it 'redirects to the accounts list' do
        subject
        expect(response).to redirect_to(admin_accounts_url)
      end
    end
  end
end

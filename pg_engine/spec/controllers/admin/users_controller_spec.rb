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

RSpec.describe Admin::UsersController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:user)
  end

  let(:invalid_attributes) do
    {
      email: nil
    }
  end

  let(:logger_user) { create :user, :admin }

  before do
    sign_in logger_user
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    let!(:user) { create :user }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end

    context 'when está descartado' do
      before { user.discard! }

      it do
        subject
        expect(assigns(:collection)).to eq [logger_user]
      end
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      user = create(:user)
      get :show, params: { id: user.to_param }
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
      user = create(:user)
      get :edit, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        post :create, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:user)
      end

      it 'updates the requested user' do
        user = create(:user)
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.email).to eq new_attributes[:email]
      end

      it 'redirects to the user' do
        user = create(:user)
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to redirect_to(user.decorate.target_object)
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        user = create(:user)
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        user = create(:user)
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      delete :destroy, params: { id: user.to_param }
    end

    let!(:user) { create :user }

    it 'destroys the requested user' do
      expect { subject }.to change(User.kept, :count).by(-1)
    end

    it 'setea el discarded_at' do
      subject
      expect(user.reload.discarded_at).to be_present
    end

    it 'redirects to the users list' do
      subject
      expect(response).to redirect_to(admin_users_url)
    end
  end
end
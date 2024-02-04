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
  # This should return the minimal set of attributes required to create a valid
  # Cosa. As you add validations to Cosa, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:cosa)
  end

  let(:user) { create :user, :admin }

  before do
    sign_in user if user.present?
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    before { create :cosa }

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
  end

  describe 'GET #show' do
    it 'returns a success response' do
      cosa = create(:cosa)
      get :show, params: { id: cosa.to_param }
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
        expect(response).to redirect_to(Cosa.last.decorate.target_object)
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
        skip('Add assertions for updated state')
      end

      it 'redirects to the cosa' do
        cosa = create(:cosa)
        put :update, params: { id: cosa.to_param, cosa: valid_attributes }
        expect(response).to redirect_to(cosa.decorate.target_object)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      delete :destroy, params: { id: cosa.to_param }
    end

    let!(:cosa) { create :cosa }

    it 'destroys the requested cosa' do
      expect { subject }.to change(Cosa, :count).by(-1)
    end

    it 'redirects to the cosas list' do
      subject
      expect(response).to redirect_to(admin_cosas_url)
    end
  end
end
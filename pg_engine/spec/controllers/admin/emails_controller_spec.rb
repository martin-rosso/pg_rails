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

RSpec.describe Admin::EmailsController do
  render_views
  # This should return the minimal set of attributes required to create a valid
  # Email. As you add validations to Email, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:email)
  end

  let(:invalid_attributes) do
    {
      from_address: nil
    }
  end

  let(:logged_user) { create :user, :developer }

  before do
    sign_in logged_user if logged_user.present?
  end

  describe 'routing' do
    it 'routes GET index correctly' do
      route = { get: '/a/emails' }
      expect(route).to route_to(controller: 'admin/emails', action: 'index')
    end
  end

  describe 'GET #index' do
    subject do
      get :index, params: {}
    end

    before { create :email }

    it 'returns a success response' do
      subject
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      let(:logged_user) { nil }

      it 'redirects to login path' do
        subject
        expect(response).to redirect_to(new_user_session_path)
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
      email = create(:email)
      email.encoded_eml.attach({ io: StringIO.new(Faker::Lorem.sentence), filename: 'email.eml' })
      get :show, params: { id: email.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      email = create(:email)
      get :edit, params: { id: email.to_param }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:email)
      end

      it 'updates the requested email' do
        email = create(:email)
        put :update, params: { id: email.to_param, email: new_attributes }
        email.reload
        expect(email.from_address).to eq new_attributes[:from_address]
      end

      it 'redirects to the email' do
        email = create(:email)
        put :update, params: { id: email.to_param, email: valid_attributes }
        expect(response).to redirect_to([:admin, email])
      end
    end

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        email = create(:email)
        put :update, params: { id: email.to_param, email: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        email = create(:email)
        put :update, params: { id: email.to_param, email: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject do
      request.headers['Accept'] = 'text/vnd.turbo-stream.html,text/html'
      delete :destroy, params: { id: email.to_param, land_on: }
    end

    let!(:email) { create :email }
    let(:land_on) { nil }

    it 'destroys the requested email' do
      expect { subject }.to change(Email, :count).by(-1)
    end

    it 'envía el pg-event' do
      subject
      expect(response.body).to include('<pg-event data-event-name="pg:record-destroyed"')
    end

    context 'si hay land_on' do
      let(:land_on) { :index }

      it 'redirects to the emails list' do
        subject
        expect(response).to redirect_to(admin_emails_url)
      end
    end
  end
end

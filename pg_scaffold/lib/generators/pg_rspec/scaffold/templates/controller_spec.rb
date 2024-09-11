# frozen_string_literal: true

# FIXME: reemplazar por requests spec
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

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller do
  render_views
<% if mountable_engine? -%>
  routes { <%= mountable_engine? %>::Engine.routes }

<% end -%>
<% referencias_requeridas.each do |atributo| -%>
  let(:<%= atributo.name %>) { create :<%= atributo.name %> }

<% end -%>
  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    attributes_for(:<%= nombre_tabla_completo_singular %>)<%= merge_referencias %>
  end
<% if attributes.any? { |at| at.required? } -%>
<% required_att = attributes.select { |at| at.required? }.first -%>

  let(:invalid_attributes) do
    {
      <%= "#{required_att.name}: nil"  %>
    }
  end
<% end -%>

  let(:logged_user) { create :user, :developer }

  before do
    sign_in logged_user if logged_user.present?
  end

  describe 'routing' do
    it 'routes GET index correctly' do
      route = { get: '/<%= controller_file_path %>' }
      expect(route).to route_to(controller: '<%= controller_file_path %>', action: 'index')
    end
  end

<% unless options[:singleton] -%>
  describe 'GET #index' do
    subject do
<% if Rails::VERSION::STRING < '5.0' -%>
      get :index, {}
<% else -%>
      get :index, params: {}
<% end -%>
    end

    let!(:<%= nombre_tabla_completo_singular %>) { create :<%= nombre_tabla_completo_singular %> }

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
<% if options[:discard] -%>

    context 'when está descartado' do
      before { <%= nombre_tabla_completo_singular %>.discard! }

      it do
        subject
        expect(assigns(:collection)).not_to include(<%= nombre_tabla_completo_singular %>)
      end
    end
<% end -%>

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

<% end -%>
  describe 'GET #show' do
    it 'returns a success response' do
      <%= file_name %> = create(:<%= nombre_tabla_completo_singular %>)
<% if Rails::VERSION::STRING < '5.0' -%>
      get :show, { id: <%= file_name %>.to_param }
<% else -%>
      get :show, params: { id: <%= file_name %>.to_param }
<% end -%>
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
<% if Rails::VERSION::STRING < '5.0' -%>
      get :new, {}
<% else -%>
      get :new, params: {}
<% end -%>
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      <%= file_name %> = create(:<%= nombre_tabla_completo_singular %>)
<% if Rails::VERSION::STRING < '5.0' -%>
      get :edit, { id: <%= file_name %>.to_param }
<% else -%>
      get :edit, params: { id: <%= file_name %>.to_param }
<% end -%>
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new <%= class_name %>' do
        expect do
<% if Rails::VERSION::STRING < '5.0' -%>
          post :create, { <%= nombre_tabla_completo_singular %>: valid_attributes }
<% else -%>
          post :create, params: { <%= nombre_tabla_completo_singular %>: valid_attributes }
<% end -%>
        end.to change(<%= class_name %>, :count).by(1)
      end

      it 'redirects to the created <%= nombre_tabla_completo_singular %>' do
<% if Rails::VERSION::STRING < '5.0' -%>
        post :create, { <%= nombre_tabla_completo_singular %>: valid_attributes }
<% else -%>
        post :create, params: { <%= nombre_tabla_completo_singular %>: valid_attributes }
<% end -%>
        expect(response).to redirect_to([:<%= ns_prefix.first %>, <%= class_name %>.last])
      end
    end
<% if attributes.any? { |at| at.required? } -%>

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        post :create, params: { <%= nombre_tabla_completo_singular %>: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new template' do
        post :create, params: { <%= nombre_tabla_completo_singular %>: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
<% end -%>
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        attributes_for(:<%= nombre_tabla_completo_singular %>)
      end

      it 'updates the requested <%= nombre_tabla_completo_singular %>' do
        <%= file_name %> = create(:<%= nombre_tabla_completo_singular %>)
<% if Rails::VERSION::STRING < '5.0' -%>
        put :update, { id: <%= file_name %>.to_param, <%= nombre_tabla_completo_singular %>: new_attributes }
<% else -%>
        put :update, params: { id: <%= file_name %>.to_param, <%= nombre_tabla_completo_singular %>: new_attributes }
<% end -%>
        <%= file_name %>.reload
<% atributo = attributes.find { |at| !at.reference? && at.required? } -%>
<% if atributo.present? -%>
        expect(<%= file_name%>.<%= atributo.name %>).to eq new_attributes[:<%= atributo.name %>]
<% else -%>
        skip('Add assertions for updated state')
<% end -%>
      end

      it 'redirects to the <%= nombre_tabla_completo_singular %>' do
        <%= file_name %> = create(:<%= nombre_tabla_completo_singular %>)
<% if Rails::VERSION::STRING < '5.0' -%>
        put :update, { id: <%= file_name %>.to_param, <%= nombre_tabla_completo_singular %>: valid_attributes }
<% else -%>
        put :update, params: { id: <%= file_name %>.to_param, <%= nombre_tabla_completo_singular %>: valid_attributes }
<% end -%>
        expect(response).to redirect_to([:<%= ns_prefix.first %>, <%= file_name %>])
      end
    end
<% if attributes.any? { |at| at.required? } -%>

    context 'with invalid params' do
      it 'returns a unprocessable_entity response' do
        <%= file_name %> = create(:<%= nombre_tabla_completo_singular %>)
        put :update, params: { id: <%= file_name %>.to_param, <%= nombre_tabla_completo_singular %>: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        <%= nombre_tabla_completo_singular %> = create(:<%= nombre_tabla_completo_singular %>)
        put :update, params: { id: <%= nombre_tabla_completo_singular %>.to_param, <%= nombre_tabla_completo_singular %>: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
<% end -%>
  end

  describe 'DELETE #destroy' do
    subject do
      request.headers['Accept'] = 'text/vnd.turbo-stream.html,text/html'
      delete :destroy, params: { id: <%= file_name %>.to_param, redirect_to: redirect_url }
    end

    let!(:<%= nombre_tabla_completo_singular %>) { create :<%= nombre_tabla_completo_singular %> }
    let(:redirect_url) { nil }

    it 'destroys the requested <%= nombre_tabla_completo_singular %>' do
<% if options[:discard] -%>
      expect { subject }.to change(<%= class_name %>.kept, :count).by(-1)
<% elsif options[:paranoia] -%>
      expect { subject }.to change(<%= class_name %>.without_deleted, :count).by(-1)
<% else -%>
      expect { subject }.to change(<%= class_name %>, :count).by(-1)
<% end -%>
    end

<% if options[:discard] -%>
    it 'setea el discarded_at' do
      subject
      expect(<%= nombre_tabla_completo_singular %>.reload.discarded_at).to be_present
    end

<% end -%>
    it 'envía el pg-event' do
      subject
      expect(response.body).to include('<pg-event data-event-name="pg:record-destroyed"')
    end

    context 'si hay redirect_to' do
      let(:redirect_url) { <%= index_helper %>_url }

      it 'redirects to the <%= table_name %> list' do
        subject
        expect(response).to redirect_to(<%= index_helper %>_url)
      end
    end
  end
end
<% end -%>

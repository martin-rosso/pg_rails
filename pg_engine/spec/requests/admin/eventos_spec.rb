require 'rails_helper'

describe 'Eventos' do
  let(:user) { create :user, :developer }

  before do
    create :user # no dev
    sign_in user
    SimpleUserNotifier.with(message: 'New post').deliver(User.all, enqueue_job: false)
  end

  it 'renders the event index' do
    get '/a/eventos'

    expect(response.body).to include 'New post'
  end

  describe 'posting events' do
    subject do
      get '/a/eventos/new'
      expect(response.body).to include 'Tooltip'
      post '/a/eventos', params: {
        evento: {
          type: 'SimpleUserNotifier',
          message: 'hola',
          target:
        }
      }
    end

    context 'cuando se manda a los devs' do
      let(:target) { 'devs' }

      it do
        expect { subject }.to change(Noticed::Notification, :count).by(1)
      end
    end

    context 'cuando se manda a todos' do
      let(:target) { 'todos' }

      it do
        expect { subject }.to change(Noticed::Notification, :count).by(2)
      end
    end

    context 'cuando hay error' do
      let(:target) { 'bla' }

      it do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

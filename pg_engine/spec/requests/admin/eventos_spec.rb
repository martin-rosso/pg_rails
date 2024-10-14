require 'rails_helper'

describe 'Eventos' do
  let(:user) { create :user, :developer }

  before do
    create :user # no dev
    sign_in user
    SimpleUserNotifier.with(message: 'New post').deliver(User.all, enqueue_job: false)
  end

  around do |example|
    perform_enqueued_jobs do
      example.run
    end
  end

  it 'renders the event index' do
    get '/a/simple_user_notifiers'

    expect(response.body).to include 'Crear simple user notifier'
  end

  describe 'posting events' do
    subject do
      get '/a/simple_user_notifiers/new'
      expect(response.body).to include 'Tooltip'
      post '/a/simple_user_notifiers', params: {
        simple_user_notifier: {
          message: 'hola',
          user_ids:,
          target:
        }
      }
      # get "/a/eventos/new?event_id=#{Noticed::Event.last.id}"
    end

    let(:record_id) { nil }
    let(:asunto) { nil }
    let(:user_ids) { nil }
    let(:message_text) { nil }
    let(:type) { 'SimpleUserNotifier' }

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

    context 'cuando se manda a usuarios específicos por mail' do
      let(:target) { 'user_ids' }
      let(:asunto) { 'subjecttt' }
      let(:user_ids) { 'user@host.com,otro@test.com' }
      let(:message_text) { 'texto' }
      let(:message) { '<h1>html</h1>' }
      let(:type) { 'EmailUserNotifier' }
      let(:record_id) { user.id }

      before do
        create :user, email: 'user@host.com'
        create :user, email: 'otro@test.com'
      end

      it do
        expect { subject }.to change(Noticed::Notification, :count).by(2)
      end
    end

    context 'cuando hay error' do
      subject do
        post '/a/simple_user_notifiers', params: {
          simple_user_notifier: {
            message: nil,
            target:
          }
        }
      end

      let(:target) { 'bla' }

      it do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

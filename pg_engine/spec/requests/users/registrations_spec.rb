require 'rails_helper'

describe 'registrations controller' do
  describe '#new' do
    subject { get '/users/sign_up' }

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    subject do
      post '/users', params: { user: { nombre:, apellido:, email:, password:, password_confirmation: } }
    end

    before do
      ActsAsTenant.current_tenant = nil
      ActsAsTenant.test_tenant = nil
    end

    let(:nombre) { Faker::Name.first_name }
    let(:apellido) { Faker::Name.last_name }
    let(:email) { Faker::Internet.email }
    let(:password) { '123123' }
    let(:password_confirmation) { password }

    it do
      expect { subject }.to change(User, :count).by(1)
    end

    it do
      expect { subject }.to change(UserAccount, :count).by(1)
    end

    it do
      expect { subject }.to change(Account, :count).by(1)
    end

    it do
      expect { subject }.to change(User, :count).by(1)
      expect(response.body).to include I18n.t('devise.registrations.signed_up_but_unconfirmed')
    end

    context 'cuando no coinciden los passwords' do
      let(:password_confirmation) { 'bla' }

      it do
        subject
        expect(response).not_to be_successful
      end
    end

    context 'cuando falla la creación de la UserAccount' do
      before do
        allow_any_instance_of(Users::RegistrationsController).to receive(:create_account_for).and_raise(StandardError)
      end

      it do
        expect { subject }.not_to change(User, :count)
      end

      it do
        expect { subject }.not_to change(UserAccount, :count)
      end

      it do
        expect { subject }.not_to change(Account, :count)
      end
    end

    context 'cuando hay tenant' do
      before do
        host! 'bien.localhost.com'
        create :account, subdomain: 'bien'
      end

      it do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'creates the user account', pending: 'subdomains not working' do
        expect { subject }.to change(UserAccount, :count).by(1)
      end

      it do
        expect { subject }.not_to change(Account, :count)
      end
    end
  end

  describe '#edit' do
    subject { get '/users/edit' }

    let(:logger_user) { create :user, :developer }

    before do
      sign_in logger_user
    end

    it do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end

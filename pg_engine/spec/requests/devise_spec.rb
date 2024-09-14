require 'rails_helper'

describe 'devise flows' do
  describe 'resend confirmation' do
    subject do
      post '/users/confirmation', params: { user: { email: user.email } }
    end

    let!(:user) { create :user, confirmed_at: nil }

    it do
      expect { subject }.to change(ActionMailer::Base.deliveries, :length).by(1)
    end

    it do
      subject
      expect(response).to redirect_to(new_user_session_path)
    end

    it do
      expect { subject }.not_to have_errored
    end
  end
end

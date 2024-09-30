require 'rails_helper'

describe 'Notifications' do
  subject do
    visit '/'
  end

  let(:user) { create :user }

  before do
    login_as user
  end

  context 'no notifications' do
    it do
      subject
      expect(page).to have_no_css('.notifications-unseen-mark')
    end
  end

  context 'with unseen notifications' do
    before do
      SimpleUserNotifier.with(message: 'probandooo').deliver(User.all)
    end

    it do
      subject
      expect(page).to have_css('.notifications-unseen-mark')
      find('.bi-bell-fill').click
      expect(page).to have_no_css('.notifications-unseen-mark', wait: 5)
      expect(page).to have_no_css('.unseen')
      click_on 'Marcar como no leído'
      expect(page).to have_css('.unseen')
    end
  end

  pending 'with read notifications'
end

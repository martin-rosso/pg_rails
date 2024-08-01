require 'rails_helper'

describe 'Resources' do
  let(:user) { create :user, :developer }
  before do
    login_as user
  end

  describe 'show modal' do
    let!(:cosa) { create :cosa }

    it do
      visit "/admin/cosas/#{cosa.id}"
      click_on 'Ver categoría'
      expect(page.find('.modal')).to have_text 'show de categoria'
    end
  end
end

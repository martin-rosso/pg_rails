require 'rails_helper'

describe 'Tooltips' do
  context 'en desktop' do
    before do
      # byebug
      driven_by :selenium_chrome_headless
      # Capybara.current_driver = :selenium_chrome
    end

    it 'se activan con hover' do
      visit '/rails/view_components/alert_component/tooltips'
      expect(page).to have_no_text('tooltip')
      find_by_id('tooltip').hover
      expect(page).to have_text('tooltip')
    end
  end

  context 'en mobile' do
    before do
      # driven_by :selenium_chrome_headless_iphone
      driven_by :selenium_chrome_iphone
      # driven_by :selenium_chrome_headless_notebook
      # Capybara.current_driver = :selenium_chrome_headless_iphone
    end

    it 'se activan con click' do
      visit '/rails/view_components/alert_component/tooltips'
      expect(page).to have_no_text('tooltip')
      find_by_id('tooltip').click
      expect(page).to have_text('tooltip')
    end
  end
end

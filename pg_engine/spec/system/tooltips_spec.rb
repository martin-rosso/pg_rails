require 'rails_helper'

describe 'Alertas' do
  before do
    driven_by ENV['DRIVER']&.to_sym || :selenium_chrome_headless_iphone
  end

  it 'los toasts desaparecen' do
    visit '/rails/view_components/alert_component/tooltips'
    expect(page).to have_no_text('tooltip')
    find_by_id('tooltip').hover
    expect(page).to have_text('tooltip')
  end
end

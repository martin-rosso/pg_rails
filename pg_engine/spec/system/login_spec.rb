# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in' do
  shared_examples 'sign_in' do
    subject do
      visit '/u/categoria_de_cosas'
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: password
      find('input[type=submit]').click
    end

    let(:password) { 'pass1234' }
    let!(:user) { create :user, password: }

    it do
      subject
      expect(page).to have_text :all, 'No hay ninguna categoría de cosa que mostrar'
    end
  end

  # drivers = %i[
  #   selenium_headless
  #   selenium_chrome_headless
  #   selenium_chrome_headless_notebook
  #   selenium_chrome_headless_iphone
  # ]
  drivers = %i[selenium_chrome_headless_iphone]
  drivers = [ENV['DRIVER'].to_sym] if ENV['DRIVER'].present?

  drivers.each do |driver|
    context("with driver '#{driver}'") do
      before do
        driven_by driver
      end

      it_behaves_like 'sign_in'
    end
  end
end

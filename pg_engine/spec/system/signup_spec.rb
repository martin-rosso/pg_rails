# frozen_string_literal: true

require 'rails_helper'

describe 'Al Registrarse' do
  include ActiveJob::TestHelper

  find_scroll = proc do |selector, options = {}|
    elem = find(selector, **options.merge(visible: :all))
    script = 'arguments[0].scrollIntoView({ behavior: "instant", block: "start", inline: "nearest" });'
    page.execute_script(script, elem)
    sleep 0.5
    elem
  end

  shared_examples 'sign_up' do
    subject do
      perform_enqueued_jobs do
        visit '/users/sign_up'
        fill_in 'user_email', with: Faker::Internet.email
        fill_in 'user_nombre', with: Faker::Name.name
        fill_in 'user_apellido', with: Faker::Name.name
        fill_in 'user_password', with: 'admin123'
        fill_in 'user_password_confirmation', with: 'admin123'

        accept_terms

        instance_exec('input[type=submit]', &find_scroll).click
      end
    end

    context 'cuando acepta los términos' do
      let(:accept_terms) do
        check 'user_accept_terms'
      end

      pending 'expect new account created also'

      it 'guarda el user' do
        expect { subject }.to change(User.unscoped, :count).by(1)
        expect(page).to have_text('Te enviamos un correo electrónico con instrucciones')
      end
    end

    context 'si no acepta los terms' do
      let(:accept_terms) do
        nil
      end

      it do
        subject
        expect(page).to have_text 'es necesario que aceptes los términos y condiciones'
      end
    end
  end

  shared_examples 'edit user' do
    subject do
      fill_in 'user_nombre', with: 'despues'
      fill_in 'user_current_password', with: password
      instance_exec('input[type=submit]', &find_scroll).click
      # find('').click
      sleep 1
    end

    let(:password) { 'pass1234' }
    let(:nombre) { 'antes' }
    let!(:user) { create :user, password:, nombre: }

    before do
      login_as user
      visit '/users/edit'
    end

    it do
      expect { subject }.to change { user.reload.nombre }.to('despues')
      expect(page).to have_text('Tu cuenta se ha actualizado')
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

      it_behaves_like 'sign_up'
      it_behaves_like 'edit user'
    end
  end
end

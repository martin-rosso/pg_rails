require 'rails_helper'

class DummyMailer < ApplicationMailer
  def test_mail
    mail(to: 'fake@mail.com') do |format|
      format.html { render inline: erb_template } # rubocop:disable Rails/RenderInline
    end
  end

  private

  def erb_template
    <<-ERB
      <%= root_url %>
    ERB
  end
end

describe PgEngine::BaseMailer do
  describe 'default_url_options', pending: 'site hosts on testing' do
    subject do
      mail.deliver
    end

    let(:mail) { DummyMailer.test_mail }

    it 'cuando elige el default' do
      expect { subject }.to have_warned('Default site brand chosen')
      expect(mail.body.encoded).to include 'factura.localhost'
      expect(mail.header_fields.get_field(:from).value).to include 'Factura Bien'
      expect(mail.header_fields.get_field(:from).value).to include 'noreply@factura'
    end

    it 'cuando es un brand específico' do
      Current.app_name = :procura
      subject
      expect(mail.body.encoded).to include 'procura.localhost'
      expect(mail.header_fields.get_field(:from).value).to include 'Procura Bien'
      expect(mail.header_fields.get_field(:from).value).to include 'noreply@procura'
    end
  end
end

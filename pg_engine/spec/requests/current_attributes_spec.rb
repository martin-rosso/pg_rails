require 'rails_helper'

describe 'current attributes' do
  it 'Current gets reset between requests' do
    allow(Current).to receive(:namespace=)
    allow(Current.instance).to receive(:reset)
    get '/contacto/new'
    expect(Current).to have_received(:namespace=).with(:public)
    expect(Current.instance).to have_received(:reset).at_least(:twice)
    expect(Current.namespace).to be_nil
  end

  it 'sets a current attribute' do
    Current.user = 1
    expect(Current.namespace).to be_nil
  end

  it 'the attribute gets reset' do
    Current.namespace = 2
    expect(Current.user).to be_nil
  end
end

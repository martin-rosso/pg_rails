require 'rails_helper'

describe 'current attributes' do
  it 'Current gets reset between requests' do
    expect(Current).to receive(:namespace=).with(:public)
    expect(Current.instance).to receive(:reset).at_least(:twice)
    get '/contacto/new'
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

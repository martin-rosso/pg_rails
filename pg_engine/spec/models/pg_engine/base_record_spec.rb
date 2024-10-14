require 'rails_helper'

describe PgEngine::BaseRecord do
  describe '#human_attribute_name' do
    it do
      obj = described_class.human_attribute_name('bla_text')
      expect(obj).to eq described_class.human_attribute_name('bla')
    end

    it do
      obj = described_class.human_attribute_name('bla_f')
      expect(obj).to eq described_class.human_attribute_name('bla')
    end
  end

  describe '#default_modal' do
    it 'the values are independent from each class' do
      model_class = Class.new(described_class)
      another_model_class = Class.new(described_class)
      model_class.default_modal = true
      another_model_class.default_modal = false
      expect(model_class.default_modal).to be true
      expect(another_model_class.default_modal).to be false
      expect(described_class.default_modal).to be_nil
    end
  end
end

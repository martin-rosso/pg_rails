require 'rails_helper'

describe PgEngine::ChildRecord do
  describe '#parent_accessor' do
    it 'the values are independent from each class' do
      model_class = Class.new(PgEngine::BaseRecord)
      another_model_class = Class.new(PgEngine::BaseRecord)
      model_class.include described_class
      another_model_class.include described_class
      model_class.parent_accessor = :one
      another_model_class.parent_accessor = :two
      expect(model_class.parent_accessor).to be :one
      expect(another_model_class.parent_accessor).to be :two
      expect { described_class.parent_accessor }.to raise_error(NoMethodError)
    end
  end

  describe '#parent?' do
    it do
      expect(create(:cosa)).to be_parent
    end

    it do
      expect(create(:categoria_de_cosa)).not_to be_parent
    end
  end
end

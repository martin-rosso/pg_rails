require 'rails_helper'

require 'generators/pg_rspec/scaffold/scaffold_generator'
require 'generators/pg_decorator/pg_decorator_generator'
require 'generators/pg_active_record/model/model_generator'
require 'generators/pg_rails/system_spec/system_spec_generator'

TEST_ENV_NUMBER = ENV.fetch('TEST_ENV_NUMBER', '')
DESTINATION_PATH = File.expand_path("./../../tmp/generator_testing#{TEST_ENV_NUMBER}", __dir__)

describe 'Generators', type: :generator do
  destination DESTINATION_PATH

  describe 'PgDecoratorGenerator' do
    tests PgDecoratorGenerator

    before { prepare_destination }

    it do
      run_generator(['users/modelo', 'bla:integer'])

      my_assert_file 'app/decorators/modelo_decorator.rb' do |content|
        expect(content).to match(/delegate_all/)
      end
    end
  end

  describe 'ScaffoldGenerator' do
    tests PgRspec::Generators::ScaffoldGenerator

    before { prepare_destination }

    it do
      run_generator(['users/modelo', 'bla:integer'])

      my_assert_file 'spec/controllers/users/modelos_controller_spec.rb' do |content|
        expect(content).to match(/routing/)
        expect(content).to match(/sign_in/)
      end
    end
  end

  describe PgActiveRecord::ModelGenerator do
    tests described_class

    before { prepare_destination }

    it do
      run_generator(['users/modelo', 'bla:integer', 'cosa:references', '--activeadmin'])

      my_assert_file 'app/admin/modelos.rb' do |content|
        expect(content).to match(/permit_params.*cosa_id/)
      end
    end
  end

  describe PgRails::SystemSpecGenerator do
    tests described_class

    before { prepare_destination }

    it do
      run_generator(['Filtros en listados'])

      my_assert_file 'spec/system/filtros_en_listados_spec.rb' do |content|
        expect(content).to match(/rails_helper/)
        expect(content).to include 'describe \'Filtros en listados\' do'
      end
    end
  end
end

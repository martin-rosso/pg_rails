# frozen_string_literal: true

# TODO: mover a pg_scaffold

module PgEngine
  class Configuracion
    attr_accessor :users_controller, :global_domains, :navigators, :user_profiles

    def initialize
      @global_domains = ['app.localhost.com', 'test.host', 'localhost']
      @navigators = [PgEngine::Navigator.new]
      @user_profiles = {
        account__owner: 0,
        user_accounts__read: 1001,
        user_accounts__write: 1010,
        user_accounts__archive: 1050,
        user_accounts__destroy: 1100,
      }
    end
  end
end

400

# frozen_string_literal: true

# TODO: mover a pg_scaffold

module PgEngine
  class Configuracion
    attr_accessor :users_controller, :global_domains, :navigators

    def initialize
      @global_domains = ['app.localhost.com', 'test.host', 'localhost']
      @navigators = [PgEngine::Navigator.new]
    end
  end
end

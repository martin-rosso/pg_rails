# frozen_string_literal: true

# TODO: mover a pg_scaffold

module PgEngine
  class Configuracion
    attr_accessor :users_controller, :global_domains

    def initialize
      if defined? UsersController
        @users_controller = UsersController
      end

      @global_domains = ['app.localhost.com', 'test.host', 'localhost']
    end
  end
end

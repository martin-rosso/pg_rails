# frozen_string_literal: true

# TODO: mover a pg_scaffold

module PgEngine
  class Configuracion
    attr_accessor :users_controller, :global_domains, :navigators, :user_profiles, :profile_groups

    def initialize
      @global_domains = ['app.localhost.com', 'test.host', 'localhost']
      @navigators = [PgEngine::Navigator.new]
      @profile_groups = [:account]
      @user_profiles = {
        account__owner: 0,
      }
      add_profiles(:user_accounts, 1000)
    end

    def add_profiles(key, base)
      profile_groups.push(key)
      user_profiles.merge!(
        "#{key}__read": base + 1,
        "#{key}__update": base + 10,
        "#{key}__add": base + 30,
        "#{key}__archive": base + 50,
        "#{key}__destroy": base + 100,
      )
    end
  end
end

400

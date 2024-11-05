# frozen_string_literal: true

# TODO: mover a pg_scaffold

module PgEngine
  class Configuracion
    attr_accessor :users_controller, :global_domains, :navigators, :user_profiles

    # attr_accessor :profile_groups

    def initialize
      @global_domains = ['app.localhost.com', 'test.host', 'localhost']
      @navigators = [PgEngine::Navigator.new]
      # @profile_groups = [:account]
      @user_profiles = {
        account__owner: 0
      }
      user_profiles.merge!(
        user_accounts__read: 1000 + 1
      )
      # add_profiles(:user_accounts, 1000)
    end

    def add_profiles(key, base)
      # profile_groups.push(key)
      user_profiles.merge!(
        "#{key}__read": base + 1,
        "#{key}__update": base + 10,
        "#{key}__create": base + 30,
        "#{key}__archive": base + 50,
        "#{key}__export": base + 80,
        "#{key}__destroy": base + 100
      )

      return unless defined? UserAccount

      UserAccount.class_eval do
        enumerize :profiles, in: PgEngine.configuracion.user_profiles, multiple: true
      end
    end

    def profile_groups_options
      groups = user_profiles.keys.map { |v| v.to_s.split('__').first }.uniq

      groups = groups.excluding('account') unless Current.namespace == :admin

      groups.map do |group|
        options = user_profiles.keys.select { |va| va.starts_with?(group) }.map do |va|
          [va, I18n.t(va.to_s.split('__').last, scope: 'profile_member')]
        end
        { name: group, options: }
      end
    end
  end
end

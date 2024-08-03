# frozen_string_literal: true

module PgEngine
  module RequireSignIn
    def self.included(clazz)
      clazz.include RansackMemory::Concern
      clazz.before_action :authenticate_user!
      clazz.before_action :save_and_load_filters
    end
  end
end

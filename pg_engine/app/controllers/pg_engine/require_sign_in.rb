# frozen_string_literal: true

module PgEngine
  module RequireSignIn
    def self.included(clazz)
      clazz.include RansackMemory::Concern
      clazz.prepend_before_action :authenticate_user!
      # dsfil: dont save filters
      clazz.before_action :save_and_load_filters, unless: -> { params[:dsfil] == '1' }
    end
  end
end

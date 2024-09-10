class Current < ActiveSupport::CurrentAttributes
  attribute :account, :user, :namespace, :controller
  # attribute :request_id, :user_agent, :ip_address

  # resets { Time.zone = nil }

  # def user=(user)
  #   super
  #
  #   Time.zone    = user.time_zone
  # end

  deprecate :account, deprecator: PgEngine.deprecator
end

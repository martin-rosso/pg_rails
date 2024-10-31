class Current < ActiveSupport::CurrentAttributes
  attribute :user, :namespace, :controller, :active_user_account
  # attribute :request_id, :user_agent, :ip_address

  # resets { Time.zone = nil }

  def tid
    active_user_account.to_param
  end

  def active_user_profiles
    if active_user_account.present?
      active_user_account.profiles
    else
      []
    end
  end

  def user_account_owner?
    active_user_profiles.include?('account__owner')
  end

  def account
    ActsAsTenant.current_tenant
  end

  # def user=(user)
  #   super
  #
  #   Time.zone    = user.time_zone
  # end
end

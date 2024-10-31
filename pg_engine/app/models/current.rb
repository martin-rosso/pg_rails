class Current < ActiveSupport::CurrentAttributes
  attribute :user, :namespace, :controller, :active_user_account
  # attribute :request_id, :user_agent, :ip_address

  # resets { Time.zone = nil }

  def active_user_account
    # Para los casos de without_tenant, ej: users/accounts#index
    return nil if account.nil?

    # En la mayoría de los casos si hay user y hay account es porque hay una
    # active_user_account salvo en el show de account que se renderea 'with_tenant'
    if attributes[:active_user_account].blank? && user.present? && account.present?
      attributes[:active_user_account] = user.active_user_account_for(account)
    end

    super
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

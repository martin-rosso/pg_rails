ActsAsTenant.configure do |config|
  config.require_tenant = true

  # Customize the query for loading the tenant in background jobs
  # config.job_scope = ->{ all }
end

Warden::Manager.after_set_user do |record, warden, options|
  scope = options[:scope]
  env   = warden.request.env

  if record && warden.authenticated?(scope) && !ActsAsTenant.unscoped?

    proxy = Devise::Hooks::Proxy.new(warden)

    if ActsAsTenant.current_tenant.blank?
      # Devise.sign_out_all_scopes ? proxy.sign_out : proxy.sign_out(scope)
      # throw :warden, scope: scope, message: :account_not_set
      # FIXME: ensure is the global domain

    elsif record.user_accounts
                .where(account_id: ActsAsTenant.current_tenant.id).none?
      Devise.sign_out_all_scopes ? proxy.sign_out : proxy.sign_out(scope)
      throw :warden, scope: scope, message: :user_not_belongs_to_account
    end
  end
end


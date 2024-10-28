ActsAsTenant.configure do |config|
  config.require_tenant = lambda do |options|
    Current.namespace.present? || !options[:model].in?([User, UserAccount, Email, EmailLog])
  end

  # Customize the query for loading the tenant in background jobs
  # config.job_scope = ->{ all }
end

SET_TENANT_PROC = lambda do
  if defined?(Rails::Console)
    if ENV['SET_DEFAULT_TENANT_ON_DEV'].present?
      puts "> ActsAsTenant.current_tenant = Account.first"
      ActsAsTenant.current_tenant = Account.first
    else
      puts "> ActsAsTenant.unscoped = true"
      ActsAsTenant.unscoped = true
    end
  end
end

Rails.application.configure do
  if Rails.env.development?
    # Set the tenant to the first account in development on load
    config.after_initialize do
      SET_TENANT_PROC.call
    end

    # Reset the tenant after calling 'reload!' in the console
    ActiveSupport::Reloader.to_complete do
      SET_TENANT_PROC.call
    end
  end
end

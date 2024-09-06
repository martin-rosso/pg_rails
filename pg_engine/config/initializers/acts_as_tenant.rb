ActsAsTenant.configure do |config|
  config.require_tenant = lambda do |options|
    if options[:scope] == User && true # global_domain?
      # tal vez en algunos casos de devise sí requeriría el tenant?
      #   creería que no, el único lugar en donde se debería queriar 
      #   User es en devise y es para obtener el current_user
      #   hay que ver luego qué pasa con invitable
      false
    else
      true
    end
  end

  # Customize the query for loading the tenant in background jobs
  # config.job_scope = ->{ all }
end

SET_TENANT_PROC = lambda do
  if defined?(Rails::Console)
    puts "> ActsAsTenant.current_tenant = Account.first"
    ActsAsTenant.current_tenant = Account.first
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

ActiveSupport.on_load :action_controller do
  if defined? UsersController
    PgEngine.configurar do |config|
      config.users_controller = UsersController
    end
  end
end

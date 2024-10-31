module Users
  class NotificationsController < PgEngine.config.users_controller
    skip_before_action :require_tenant_set

    def mark_as_unseen
      notification = Noticed::Notification.find(params[:id])
      notification.mark_as_unseen!
      head :ok
    end

    def mark_as_seen
      # No handleo errores porque no debería fallar, y si falla
      # se notifica a rollbar y al user no le pasa nada
      notifications = Noticed::Notification.where(id: params[:ids].split(','))
      notifications.each(&:mark_as_seen!)
      head :ok
    end
  end
end

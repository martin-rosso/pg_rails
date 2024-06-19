# To deliver this notification:
#
# SimpleUserNotifier.with(message: "New post").deliver(User.all, enqueue_job: false)

class SimpleUserNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end
  notification_methods do
    def message
      params[:message]
    end

    def tooltip
      params[:tooltip]
    end
  end
  # Add required params
  #
  required_param :message
end

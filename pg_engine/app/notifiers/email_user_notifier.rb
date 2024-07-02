class EmailUserNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = 'PgEngine::UserMailer'
    config.method = 'notification'
  end

  required_param :message, :subject
end

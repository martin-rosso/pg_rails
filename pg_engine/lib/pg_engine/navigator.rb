module PgEngine
  class Navigator
    # rubocop:disable Metrics/MethodLength
    def configure(navbar)
      # *****************************************************

      navbar.add_item('sidebar.signed_in', {
                        name: 'Inicio',
                        path: 'tenant_root_path',
                        priority: 0
                      })

      # *****************************************************

      return unless Current.namespace == :admin

      navbar.add_item('sidebar.signed_in', {
                        name: 'Eventos',
                        path: 'admin_simple_user_notifiers_path'
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'Emails',
                        path: 'admin_emails_path'
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'Email logs',
                        path: 'admin_email_logs_path'
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'Users',
                        path: 'admin_users_path'
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'Accounts',
                        path: 'admin_accounts_path'
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'User Accounts',
                        path: 'admin_user_accounts_path'
                      })
    end
    # rubocop:enable Metrics/MethodLength
  end
end

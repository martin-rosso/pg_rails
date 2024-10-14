module PgEngine
  class Navigator
    # rubocop:disable Metrics/MethodLength
    def configure(navbar)
      navbar.add_item('sidebar.not_signed_in', {
                        name: 'Crear una cuenta',
                        path: 'new_user_registration_path'
                      })
      navbar.add_item('sidebar.not_signed_in', {
                        name: 'Iniciar sesión',
                        path: 'new_user_session_path'
                      })
      navbar.add_item('sidebar.not_signed_in', {
                        name: 'Contacto',
                        path: 'new_public_mensaje_contacto_path'
                      })

      # *****************************************************

      navbar.add_item('sidebar.signed_in', {
                        name: 'Inicio',
                        path: 'users_root_path',
                        priority: 0
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'Mi perfil',
                        path: 'edit_user_registration_path',
                        policy: 'policy(Current.user).edit?'
                      })
      navbar.add_item('sidebar.signed_in', {
                        name: 'Cerrar sesión',
                        path: 'destroy_user_session_path',
                        attributes: 'data-turbo-method="delete"'
                      })

      # *****************************************************

      return unless Current.user&.developer?

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

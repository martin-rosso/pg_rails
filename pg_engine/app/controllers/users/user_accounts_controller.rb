# frozen_string_literal: true

# generado con pg_rails

module Users
  class UserAccountsController < PgEngine.config.users_controller
    include PgEngine::Resource

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id
    self.skip_default_breadcrumb = true

    skip_before_action :require_tenant_set, only: %i[destroy accept_invitation]

    before_action only: :accept_invitation do
      set_instancia_modelo

      unless @user_account.membership_status.invited?
        pg_warn('User was not invited and tried to accept invitation')
        redirect_back(fallback_location: root_path, status: 303)
      end
    end

    def accept_invitation
      @user_account.update(membership_status: :active)

      if accepts_turbo_stream?
        body = <<~HTML.html_safe
          <pg-event data-event-name="pg:record-updated" data-turbo-temporary>
          </pg-event>
        HTML
        render turbo_stream: turbo_stream.append_all('body', body)
      else
        redirect_back(fallback_location: root_path, status: 303)
      end
    end

    private

    def atributos_permitidos
      [
        { profiles: [] }
      ]
    end

    def set_instancia_modelo
      ActsAsTenant.without_tenant do
        super
      end
    end
  end
end

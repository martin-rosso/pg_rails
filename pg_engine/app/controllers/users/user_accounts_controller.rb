# frozen_string_literal: true

# generado con pg_rails

module Users
  class UserAccountsController < PgEngine.config.users_controller
    include PgEngine::Resource

    skip_before_action :require_tenant_set, only: %i[destroy accept_invitation]

    before_action only: :accept_invitation do
      set_instancia_modelo
    end

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id

    def accept_invitation
      # FIXME: check invited
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
        :membership_status,
        { profiles: [] }
      ]
    end

    def set_instancia_modelo
      ActsAsTenant.without_tenant do
        super
      end
    end

    # def atributos_para_buscar
    #   %i[user account profiles]
    # end

    # def atributos_para_listar
    #   %i[user account profiles]
    # end

    # def atributos_para_mostrar
    #   %i[user account profiles]
    # end
  end
end

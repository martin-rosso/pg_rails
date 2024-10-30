# frozen_string_literal: true

# generado con pg_rails

# FIXME: on index:
#  - if @current_tenant_set_by_domain_or_subdomain
#    p Estás en el dominio de #{ActsAsTenant.current_tenant} (#{request.host})
#    p
#      | Para cambiar de cuenta vas a tener que iniciar sesión en el dominio
#      |< de Bien o de la cuenta específica a la que quieras cambiar

module Users
  class AccountsController < UsersController
    around_action :set_tenant, only: :show
    def set_tenant
      acc = Account.find(params[:id])
      # FIXME: y si en vez de esto, directamente seteo las default_url_options?
      ActsAsTenant.with_tenant(acc) do
        # Monkeypatch to force url_options to be regenerated
        @_url_options = nil

        yield
      end
    end
    include PgEngine::Resource

    before_action do
      @no_main_frame = true
      @breadcrumbs_on_rails = []
      @sidebar = false
    end

    add_breadcrumb 'Cuentas', ->(h) { h.users_accounts_path(tenant_id: nil) }

    self.clase_modelo = Account
    self.skip_default_breadcrumb = true

    around_action :set_without_tenant, only: :index
    def set_without_tenant(&)
      ActsAsTenant.without_tenant(&)
    end
    # layout 'pg_layout/containerized'

    skip_before_action :require_tenant_set, only: %i[new create show index]

    # La user_account puede estar disabled
    def show
      add_breadcrumb @account, users_account_path(@account, tenant_id: nil)

      @user_account = Current.user.user_account_for(@account).decorate
    end

    # private

    def atributos_permitidos
      %i[nombre plan]
    end

    def atributos_para_buscar
      []
    end

    def atributos_para_listar
      %i[nombre plan owner]
    end

    def atributos_para_mostrar
      atributos_permitidos
    end
  end
end

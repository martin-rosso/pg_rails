# frozen_string_literal: true

# generado con pg_rails

# TODO!: on index: (para cuando active los subdomains)
#  - if @current_tenant_set_by_domain_or_subdomain
#    p Estás en el dominio de #{ActsAsTenant.current_tenant} (#{request.host})
#    p
#      | Para cambiar de cuenta vas a tener que iniciar sesión en el dominio
#      |< de Bien o de la cuenta específica a la que quieras cambiar

module Users
  class AccountsController < UsersController
    include PgEngine::Resource
    self.clase_modelo = Account
    self.skip_default_breadcrumb = true

    skip_before_action :require_tenant_set

    before_action do
      # @no_main_frame = true
      @breadcrumbs_on_rails = []
      @sidebar = false
    end

    add_breadcrumb 'Cuentas', ->(h) { h.users_accounts_path(tenant_id: nil) }

    around_action :set_tenant, only: :show
    def set_tenant(&)
      ActsAsTenant.with_tenant(@account, &)
    end

    around_action :set_without_tenant, except: :show
    def set_without_tenant(&)
      ActsAsTenant.without_tenant(&)
    end

    # La user_account puede estar disabled
    def show
      add_breadcrumb @account, users_account_path(@account, tenant_id: nil)

      @user_account = Current.user.user_account_for(@account).decorate
      @user_accounts = policy_scope(UserAccount).where(account: @account).regulars.order(:id).to_a
    end

    private

    def atributos_permitidos
      %i[nombre plan]
    end

    def atributos_para_buscar
      []
    end

    def atributos_para_listar
      %i[nombre plan owner]
    end
  end
end

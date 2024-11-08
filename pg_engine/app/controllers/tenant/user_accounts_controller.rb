# frozen_string_literal: true

# generado con pg_rails

module Tenant
  class UserAccountsController < PgEngine::TenantController
    include PgEngine::Resource

    self.clase_modelo = UserAccount
    self.skip_default_breadcrumb = true

    before_action do
      @sidebar = false
      unless modal_targeted? || frame_embedded?
        add_breadcrumb Account.nombre_plural, ->(h) { h.users_accounts_path(tid: nil) }
        add_breadcrumb ActsAsTenant.current_tenant, users_account_path(Current.account, tid: nil)
      end
      unless modal_targeted?
        add_breadcrumb UserAccount.nombre_plural, tenant_user_accounts_path
      end
    end

    def default_sort
      'id asc'
    end

    private

    def atributos_permitidos
      [
        :membership_status, { profiles: [] }
      ]
    end

    def atributos_para_buscar
      []
    end

    def atributos_para_listar
      if Current.user_account_owner?
        %i[user user_email_f profiles_f estado_f]
      else
        %i[user user_email_f]
      end
    end
  end
end

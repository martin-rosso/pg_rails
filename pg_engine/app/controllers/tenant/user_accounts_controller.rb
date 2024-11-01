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
        add_breadcrumb Account.model_name.human(count: 2), ->(h) { h.users_accounts_path(tid: nil) }
        add_breadcrumb ActsAsTenant.current_tenant, users_account_path(Current.account, tid: nil)
      end
      unless modal_targeted?
        add_breadcrumb 'Usuarios', tenant_user_accounts_path
      end
      @actions = [
        [
          'Agregar usuario',
          new_user_invitation_path(tid: Current.tid),
          { class: 'me-1 btn btn-warning btn-sm', 'data-turbo-frame': :_top }
        ]
      ]
    end

    before_action do
      unless modal_targeted?
        # add_breadcrumb @user_account.account, users_account_path(@user_account.account, tid: nil)
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
      %i[user user_email_f profiles_f estado_f]
    end
  end
end

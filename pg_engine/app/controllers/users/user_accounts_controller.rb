# frozen_string_literal: true

# generado con pg_rails

module Users
  class UserAccountsController < PgEngine.config.users_controller
    around_action :set_without_tenant
    def set_without_tenant(&)
      ActsAsTenant.without_tenant(&)
    end

    include PgEngine::Resource
    skip_before_action :require_tenant_set

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id
    self.skip_default_breadcrumb = true

    before_action do
      # @no_main_frame = true
      @breadcrumbs_on_rails = []
      @sidebar = false
      unless modal_targeted?
        add_breadcrumb 'Cuentas', ->(h) { h.users_accounts_path(tenant_id: nil) }
      end
    end

    before_action only: :update_invitation do
      set_instancia_modelo
    end

    before_action only: %i[show edit update] do
      unless modal_targeted?
        add_breadcrumb @user_account.account, users_account_path(@user_account.account, tenant_id: nil)
      end
    end

    def update_invitation
      invitation_status = if params[:reject] == '1'
                            :ist_rejected
                          elsif params[:sign_off] == '1'
                            :ist_signed_off
                          elsif params[:accept] == '1'
                            :ist_accepted
                          else
                            # :nocov:
                            raise PgEngine::BadUserInput, 'Solicitud incorrecta'
                            # :nocov:
                          end

      @user_account.update(invitation_status:)

      redirect_to users_accounts_path
    end

    private

    def atributos_permitidos
      [
        :membership_status, { profiles: [] }
      ]
    end
  end
end

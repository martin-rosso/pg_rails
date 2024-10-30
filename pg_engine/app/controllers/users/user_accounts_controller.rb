# frozen_string_literal: true

# generado con pg_rails

module Users
  class UserAccountsController < PgEngine.config.users_controller
    include PgEngine::Resource

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id
    self.skip_default_breadcrumb = true

    skip_before_action :require_tenant_set, only: %i[destroy update_invitation]

    around_action :set_without_tenant, only: :update_invitation
    def set_without_tenant
      ActsAsTenant.without_tenant do
        set_instancia_modelo
        yield
      end
    end

    def update_invitation
      invitation_status = if params[:reject] == '1'
                            :ist_rejected
                          elsif params[:sign_off] == '1'
                            :ist_signed_off
                          else
                            :ist_accepted
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

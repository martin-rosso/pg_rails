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

    add_breadcrumb Account.model_name.human(count: 2), ->(h) { h.users_accounts_path(tid: nil) }

    layout :set_layout
    def set_layout
      if action_name == 'index'
        'pg_layout/containerized'
      else
        super
      end
    end

    before_action do
      if action_name.in? %w[index]
        @container_class = 'container border p-0 my-3'
        @container_style = 'max-width: 50em; xborder-left: 1px solid grey'
      elsif action_name.in? %w[edit update]
        @container_class = 'container border pb-3 my-3'
        @container_style = 'max-width: 50em; xborder-left: 1px solid grey'
      end
    end

    # La user_account puede estar disabled
    def show
      add_breadcrumb @account, users_account_path(@account, tid: nil)

      @user_account = Current.user.user_account_for(@account).decorate
    end

    def update_invitation
      set_instancia_modelo
      @user_account = Current.user.user_account_for(@account)

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
      %i[nombre logo plan]
    end

    def atributos_para_buscar
      []
    end

    def atributos_para_listar
      %i[nombre owner]
    end
  end
end

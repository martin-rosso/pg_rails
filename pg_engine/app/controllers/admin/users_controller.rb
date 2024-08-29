# frozen_string_literal: true

# generado con pg_rails

module Admin
  class UsersController < AdminController
    include PgEngine::Resource

    self.clase_modelo = User

    before_action(only: :index) { authorize User }

    before_action only: %i[update] do
      params[:user].delete(:password) if params[:user][:password].blank?
    end

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    add_breadcrumb User.nombre_plural, :admin_users_path

    def create
      @user.skip_confirmation!
      @user.user_accounts << UserAccount.new(account: Current.account)
      pg_respond_create
    end

    def update
      @user.skip_reconfirmation!
      pg_respond_update
    end

    # TODO: sacar este método a otro lado, que no sea AdminController
    skip_before_action :authenticate_user!, only: [:login_as]

    # :nocov:
    def login_as
      return unless dev_user_or_env?

      usuario = User.find(params[:id])
      if usuario.confirmed_at.present?
        sign_in(:user, usuario)
        redirect_to after_sign_in_path_for(usuario)
      else
        go_back('No está confirmado')
      end
    end
    # :nocov:

    private

    def atributos_permitidos
      %i[email nombre apellido password developer]
    end

    def atributos_para_buscar
      %i[email nombre apellido developer]
    end

    def atributos_para_listar
      %i[email nombre apellido confirmed_at developer]
    end

    def atributos_para_mostrar
      %i[email nombre apellido confirmed_at developer]
    end
  end
end

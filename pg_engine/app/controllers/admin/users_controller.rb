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

    def create
      @user.skip_confirmation!
      @user.orphan = true

      pg_respond_create
    end

    def update
      @user.skip_reconfirmation!
      pg_respond_update
    end

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

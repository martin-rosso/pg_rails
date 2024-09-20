# frozen_string_literal: true

# generado con pg_rails

module Admin
  class UserAccountsController < AdminController
    include PgEngine::Resource

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id

    before_action(only: :index) { authorize UserAccount }

    before_action :set_instancia_modelo, only: %i[new create show edit update destroy]

    private

    def atributos_permitidos
      [
        :user_id,
        :account_id,
        { profiles: [] }
      ]
    end

    def atributos_para_buscar
      %i[user account profiles]
    end

    def atributos_para_listar
      %i[user account profiles]
    end

    def atributos_para_mostrar
      %i[user account profiles]
    end
  end
end

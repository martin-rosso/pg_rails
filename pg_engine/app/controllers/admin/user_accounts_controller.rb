# frozen_string_literal: true

# generado con pg_rails

module Admin
  class UserAccountsController < AdminController
    include PgEngine::Resource

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id

    private

    def atributos_permitidos
      [
        :user_id,
        :account_id,
        { profiles: [] }
      ]
    end

    def atributos_para_buscar
      %i[user account profiles_arr_cont]
    end

    def atributos_para_listar
      %i[user account profiles_f]
    end

    def atributos_para_mostrar
      %i[user account]
    end
  end
end

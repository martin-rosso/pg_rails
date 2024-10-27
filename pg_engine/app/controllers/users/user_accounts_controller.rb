# frozen_string_literal: true

# generado con pg_rails

module Users
  class UserAccountsController < PgEngine.config.users_controller
    include PgEngine::Resource

    self.clase_modelo = UserAccount
    self.nested_class = Account
    self.nested_key = :account_id

    private

    def atributos_permitidos
      [
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

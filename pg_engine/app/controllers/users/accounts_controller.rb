# frozen_string_literal: true

# generado con pg_rails

module Users
  class AccountsController < UsersController
    include PgEngine::Resource

    self.clase_modelo = Account
    add_breadcrumb 'Cuentas'
    self.skip_default_breadcrumb = true

    before_action(only: :index) { authorize Account }

    # private

    # def atributos_permitidos
    #   %i[plan nombre domain subdomain]
    # end

    # def atributos_para_buscar
    #   atributos_permitidos
    # end

    # def atributos_para_listar
    #   atributos_permitidos
    # end

    # def atributos_para_mostrar
    #   atributos_permitidos
    # end
  end
end

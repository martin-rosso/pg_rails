# frozen_string_literal: true

# generado con pg_rails

module Admin
  class AccountsController < AdminController
    include PgEngine::Resource

    self.clase_modelo = Account

    private

    def atributos_permitidos
      %i[plan nombre domain subdomain]
    end

    def atributos_para_buscar
      atributos_permitidos
    end

    def atributos_para_listar
      atributos_permitidos
    end

    def atributos_para_mostrar
      atributos_permitidos
    end
  end
end

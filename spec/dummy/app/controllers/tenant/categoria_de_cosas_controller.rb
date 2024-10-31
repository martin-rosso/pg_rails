# frozen_string_literal: true

# generado con pg_rails

module Tenant
  class CategoriaDeCosasController < PgEngine::TenantController
    include PgEngine::Resource

    self.clase_modelo = CategoriaDeCosa

    private

    def atributos_permitidos
      %i[nombre tipo fecha tiempo]
    end

    def atributos_para_buscar
      %i[nombre tipo fecha tiempo]
    end

    def atributos_para_listar
      %i[nombre_f tipo fecha tiempo]
    end

    def atributos_para_mostrar
      %i[nombre tipo fecha tiempo]
    end
  end
end

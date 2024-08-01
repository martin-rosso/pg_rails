# frozen_string_literal: true

# generado con pg_rails

class CosaPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      # scope.where.not(tipo: :los)
      scope.all
    end
  end

  # def puede_editar?
  #   acceso_total? && !record.readonly?
  # end

  # def puede_crear?
  #   acceso_total? || user.asesor?
  # end

  # def puede_borrar?
  #   acceso_total? && !record.readonly?
  # end

  # def acceso_total?
  #   user.developer?
  # end
end

# frozen_string_literal: true

# generado con pg_rails

class CosaPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
      #
      # FIXME: testear
      # scope.where.not(tipo: :los)
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
  #
  def restore?
    super && record.categoria_de_cosa.kept?
  end

  def base_access_to_record?
    true
  end

  def base_access_to_collection?
    true
  end
end

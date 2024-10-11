# frozen_string_literal: true

# generado con pg_rails

class CategoriaDeCosaPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # def resolve
    #   if policy.acceso_total?
    #     scope.all
    #   else
    #     scope.none
    #   end
    # end
  end

  # def puede_editar?
  #   false
  # end

  # def puede_crear?
  #   acceso_total? || user.asesor?
  # end

  # def puede_borrar?
  #   acceso_total? && !record.readonly?
  # end

  # def new_from_associable?
  #   false
  # end

  def base_access_to_record?
    user.present?
  end

  def base_access_to_collection?
    user.present?
  end
end

# frozen_string_literal: true

# generado con pg_rails

class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
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
  def puede_editar?
    base_access_to_record?
  end

  def new_from_associable?
    false
  end

  def base_access_to_record?
    Current.namespace == :admin || user == record
  end

  def base_access_to_collection?
    user.present?
  end
end

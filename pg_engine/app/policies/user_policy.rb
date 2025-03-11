# frozen_string_literal: true

# generado con pg_rails

class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if Current.namespace == :admin
        scope.all
      elsif Current.account.present?
        ids = Current.account.user_accounts.ua_active.pluck(:user_id)
        scope.where(id: ids)
      else
        scope.none
      end
    end
  end

  # def puede_editar?
  #   acceso_total? && !record.readonly?
  # end

  def puede_crear?
    # acceso_total? || user.asesor?
    true
  end

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

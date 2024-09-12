# frozen_string_literal: true

# generado con pg_rails

class AccountPolicy < ApplicationPolicy
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
  def base_access_to_record?
    ActsAsTenant.unscoped? ||
      record.user_accounts.pluck(:user_id).include?(user.id)
  end
end

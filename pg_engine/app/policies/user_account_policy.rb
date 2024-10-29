# frozen_string_literal: true

# generado con pg_rails

class UserAccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # FIXME: quizá scopear las user_accounts según user y/o según account
    # def resolve
    #   if policy.acceso_total?
    #     scope.all
    #   else
    #     scope.none
    #   end
    # end
  end

  # FIXME: revissssar
  def accept_invitation?
    true
  end

  def puede_editar?
    user_has_profile(:user_accounts__update)
  end

  def puede_borrar?
    user_has_profile(:user_accounts__destroy)
  end

  def puede_crear?
    user_has_profile(:user_accounts__add)
  end

  # def puede_borrar?
  #   acceso_total? && !record.readonly?
  # end

  # def acceso_total?
  #   user.developer?
  # end
  def base_access_to_collection?
    user_has_profile(:user_accounts__read)
  end
end

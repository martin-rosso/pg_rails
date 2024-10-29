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
end

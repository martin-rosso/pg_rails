# frozen_string_literal: true

# generado con pg_rails

class UserAccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # FIXME: quizá scopear las user_accounts según user y/o según account
    def resolve
      if user.profiles.account__owner?
        scope.kept
      else
        # FIXME: usar scope de active
        scope.kept.where(membership_status: :active)
      end
    end
  end
  # FIXME: testear que users regulares no puedan acceder al show

  # FIXME: revissssar
  def accept_invitation?
    true
  end

  def edit?
    super && !record.profiles.account__owner?
  end

  def destroy?
    super && !record.profiles.account__owner?
  end
end

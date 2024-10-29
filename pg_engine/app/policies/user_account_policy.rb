# frozen_string_literal: true

# generado con pg_rails

class UserAccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    # FIXME: quizá scopear las user_accounts según user y/o según account
    def resolve
      if user.developer?
        scope.all
      elsif user.profiles.account__owner?
        scope.kept
      else
        # FIXME: usar scope de active
        scope.kept.where(membership_status: :active)
      end
    end
  end

  # FIXME: revissssar
  def accept_invitation?
    true
  end

  def edit?
    super && (user.developer? || !record.profiles.account__owner?)
  end

  def destroy?
    super && (user.developer? || !record.profiles.account__owner?)
  end

  # FIXME: testear que users regulares no puedan acceder al show
  def show?
    AccountPolicy.new(user, record.account).owner?
  end
end

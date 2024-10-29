# frozen_string_literal: true

# generado con pg_rails

class UserAccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.developer?
        scope.all
      elsif user.owns_current_account?
        # Account owners only see Users that are not discarded
        scope.kept
      else
        # Regulars users only see active users
        scope.active
      end
    end
  end

  def accept_invitation?
    record.membership_status.invited? && user.id == record.user_id
  end

  def edit?
    super && (user.developer? || !record.owns_current_account?)
  end

  def destroy?
    super && (user.developer? || !record.owns_current_account?)
  end

  def show?
    user.developer? || user.owns_current_account?
  end
end

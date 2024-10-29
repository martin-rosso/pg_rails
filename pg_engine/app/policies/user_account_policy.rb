# frozen_string_literal: true

# generado con pg_rails

class UserAccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
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

  def accept_invitation?
    record.membership_status.invited? && user.id == record.user_id
  end

  def edit?
    super && (user.developer? || !record.profiles.account__owner?)
  end

  def destroy?
    super && (user.developer? || !record.profiles.account__owner?)
  end

  def show?
    AccountPolicy.new(user, record.account).owner?
  end
end

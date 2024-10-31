# frozen_string_literal: true

# generado con pg_rails

class UserAccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if Current.namespace == :admin
        scope.all
      elsif Current.user_account_owner?
        # Account owners only see Users that are not discarded
        scope.kept
      else
        # Regulars users only see active users
        scope.active
      end
    end
  end

  def index?
    super && (Current.namespace == :admin || Current.active_user_account.present?)
  end

  def sign_off?
    user.id == record.user_id &&
      !record.ua_invite_pending? &&
      !record.profiles.account__owner?
  end

  def accept_invitation_link?
    user.id == record.user_id && record.ua_invite_pending?
  end

  def update_invitation?
    user.id == record.user_id
  end

  def ingresar?
    record.user == user && record.ua_active?
  end

  def edit?
    super &&
      (Current.namespace == :admin ||
       (!record.profiles.account__owner? && !record.discarded_by_user?))
  end

  def destroy?
    super && (Current.namespace == :admin || !record.profiles.account__owner?)
  end

  def show?
    Current.namespace == :admin || Current.user_account_owner?
  end
end

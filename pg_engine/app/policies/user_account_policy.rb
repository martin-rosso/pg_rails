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
        scope.ua_active
      end
    end
  end

  def index?
    super && (Current.namespace == :admin || Current.active_user_account.present?)
  end

  def sign_off?
    user_is_user_account_user? &&
      !record.ua_invite_pending? &&
      !record.profiles.account__owner?
  end

  def puede_crear?
    Current.namespace == :admin
  end

  def accept_invitation_link?
    user_is_user_account_user? && record.ua_invite_pending?
  end

  def ingresar?
    user_is_user_account_user? && record.ua_active?
  end

  def puede_editar?
    Current.namespace == :admin ||
      (user_is_account_owner? && !record.discarded_by_user? && !record.profiles.account__owner?)
  end

  def destroy?
    Current.namespace == :admin || (user_is_account_owner? && !record.profiles.account__owner?)
  end

  def show?
    Current.namespace == :admin || user_is_account_owner?
  end

  def user_is_account_owner?
    record.account.owner == user
  end

  def user_is_user_account_user?
    user.id == record.user_id
  end

  def export?
    false
  end
end

# frozen_string_literal: true

# generado con pg_rails

class AccountPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if Current.namespace == :admin
        scope.all
      else
        ary = ActsAsTenant.without_tenant do
          Current.user.user_accounts.kept.not_discarded_by_user.pluck(:account_id)
        end
        scope.where(id: ary)
      end
    end
  end

  def update_invitation?
    user_belongs_to_account?
  end

  def puede_editar?
    Current.namespace == :admin || record.owner == Current.user
  end

  def puede_crear?
    user.present?
  end

  def puede_borrar?
    Current.namespace == :admin
  end

  def new_from_associable?
    false
  end

  def show?
    Current.namespace == :admin || (base_access_to_record? && !user_account.ua_invite_pending?)
  end

  def index?
    base_access_to_collection?
  end

  def base_access_to_collection?
    user.present?
  end

  def base_access_to_record?
    Current.namespace == :admin || user_belongs_to_account?
  end

  def user_belongs_to_account?
    user_account.present?
  end

  private

  def user_account
    @user_account ||= user.user_account_for(record)
  end
end

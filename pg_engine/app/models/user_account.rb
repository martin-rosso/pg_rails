# frozen_string_literal: true

# == Schema Information
#
# Table name: user_accounts
#
#  id                 :bigint           not null, primary key
#  profiles           :integer          default([]), not null, is an Array
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  account_id         :bigint           not null, indexed
#  actualizado_por_id :bigint           indexed
#  creado_por_id      :bigint           indexed
#  user_id            :bigint           not null, indexed
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#  fk_rails_...  (user_id => users.id)
#

class UserAccount < ApplicationRecord
  audited
  include Hashid::Rails

  # self.inline_editable_fields = %i[profiles]
  self.default_modal = true

  belongs_to :user, inverse_of: :user_accounts
  acts_as_tenant :account

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  validates :user_id, uniqueness: { scope: :account_id }

  after_destroy :cleanup_invitation
  def cleanup_invitation
    usr = User.unscoped.find(user_id)
    return unless usr.invited_to_sign_up? && !usr.confirmed?
    return if usr.destroy
    # :nocov:

    pg_err 'User couldnt be deleted on invitation cleanup'
    # :nocov:
  end
  # El problema está en el joins(:user), ya que la default scope de user está scopeada dentro
  # del current_tenant entonces vuelve sobre la tabla user_accounts y bardea
  #
  # Tengo que escribir el user joins a mano porque de lo contrario sumaría la default_scope de
  # User, que a su vez joinea con user_accounts
  USER_JOINS = 'INNER JOIN users ON users.id = user_accounts.user_id'
  scope :kept, -> { joins(USER_JOINS, :account).merge(Account.kept).merge(User.unscoped.kept) }

  scope :active, lambda {
    # ua = UserAccount.arel_table
    # ua[:membership_status].eq(:active).and(ua[:invitation_status].eq(:accepted))
    # kept.and(UserAccount.owners.or(UserAccount.where(membership_status: :active, invitation_status: :accepted)))
    kept.where(membership_status: :active, invitation_status: :accepted)
  }
  scope :invitations, -> { kept.where(membership_status: :active, invitation_status: :invited) }

  OWNERS_PREDICATE = lambda do
    UserAccount.arel_table[:profiles].contains([UserAccount.profiles.account__owner.value])
  end

  scope :owners, lambda {
    where(OWNERS_PREDICATE.call)
  }

  scope :regulars, lambda {
    where.not(OWNERS_PREDICATE.call)
  }

  # Se usa en schema.rb, default: 1
  enumerize :membership_status, in: {
    active: 1,
    disabled: 2
  }

  # Se usa en schema.rb, default: 1
  enumerize :invitation_status, in: {
    accepted: 1,
    invited: 2
  }

  enumerize :profiles, in: PgEngine.configuracion.user_profiles, multiple: true

  delegate :to_s, to: :user
end

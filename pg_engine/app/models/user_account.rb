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

  scope :kept, -> { joins(:user, :account).merge(Account.kept).merge(User.kept).distinct }

  scope :owners, -> { where('user_accounts.profiles @> ARRAY[?]', UserAccount.profiles.account__owner.value) }

  # Se usa en schema.rb, default: 2
  enumerize :membership_status, in: {
    disabled: 0,
    invited: 1,
    active: 2
  }

  enumerize :profiles, in: PgEngine.configuracion.user_profiles, multiple: true

  delegate :to_s, to: :user

  def self.profile_groups
    groups = profiles.values.map { |v| v.to_s.split('__').first }.uniq
    groups.map do |group|
      options = profiles.values.select { |va| va.starts_with?(group) }.map do |va|
        [va, va.to_s.split('__').last]
      end
      { name: group, options: }
    end
  end
end

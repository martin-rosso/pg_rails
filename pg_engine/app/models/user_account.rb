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

# FIXME: add column active?
class UserAccount < ApplicationRecord
  audited
  include Hashid::Rails

  belongs_to :user, inverse_of: :user_accounts
  acts_as_tenant :account

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  # scope :kept, -> { undiscarded.joins(:account).merge(Account.kept) }
  # FIXME: merge with User.kept
  scope :kept, -> { joins(:account).merge(Account.kept) }

  enumerize :profiles, in: {
    administracion: 1,
    operacion: 2,
    lectura: 3
  }, multiple: true
end

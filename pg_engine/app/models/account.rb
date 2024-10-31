# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                 :bigint           not null, primary key
#  discarded_at       :datetime
#  nombre             :string           not null
#  plan               :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  actualizado_por_id :bigint           indexed
#  creado_por_id      :bigint           indexed
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#

class Account < ApplicationRecord
  audited
  include Discard::Model
  include Hashid::Rails

  has_many :user_accounts, dependent: :destroy
  has_many :users, through: :user_accounts

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  enumerize :plan, in: { completar: 0, los: 1, valores: 2 }

  validates :plan, :nombre, presence: true

  has_many :audits, dependent: :nullify, class_name: 'Audited::Audit'

  ransacker :search do |parent|
    parent.table[:nombre]
  end

  after_create do
    if creado_por.present?
      ActsAsTenant.without_tenant do
        user_accounts.create!(account: self, user: creado_por, profiles: [:account__owner])
      end
    end
  end

  before_validation do
    self.plan = 0 if plan.blank?
  end

  def self.gender
    'f'
  end

  def to_s
    nombre
  end

  # There can be only one
  def owner
    @owner ||= ActsAsTenant.without_tenant do
      user_accounts.ua_active.owners.first&.user
    end

    raise PgEngine::Error, 'orphan account' if @owner.nil?

    @owner
  end
end

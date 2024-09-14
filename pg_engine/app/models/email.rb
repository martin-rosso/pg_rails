# frozen_string_literal: true

# == Schema Information
#
# Table name: emails
#
#  id                 :bigint           not null, primary key
#  accepted_at        :datetime
#  associated_type    :string           indexed => [associated_id]
#  body_input         :string
#  delivered_at       :datetime
#  from_address       :string           not null
#  from_name          :string
#  mailer             :string
#  opened_at          :datetime
#  reply_to           :string
#  status             :integer          default("pending"), not null
#  status_detail      :string
#  subject            :string
#  tags               :string           is an Array
#  to                 :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  actualizado_por_id :bigint           indexed
#  associated_id      :bigint           indexed => [associated_type]
#  creado_por_id      :bigint           indexed
#  message_id         :string
#
# Foreign Keys
#
#  fk_rails_...  (actualizado_por_id => users.id)
#  fk_rails_...  (creado_por_id => users.id)
#

class Email < ApplicationRecord
  include Hashid::Rails
  audited

  self.default_modal = true

  after_commit do
    associated.email_updated(self) if associated.respond_to? :email_updated
  end

  attr_accessor :require_body_input

  has_one_attached :encoded_eml

  acts_as_tenant :account, optional: true
  tenantable_belongs_to :associated, polymorphic: true, optional: true,
                                     assign_tenant_from_associated: true

  belongs_to :creado_por, optional: true, class_name: 'User'
  belongs_to :actualizado_por, optional: true, class_name: 'User'

  has_many :email_logs, dependent: :destroy

  # TODO: y el fallido temporario?
  enumerize :status, in: { pending: 0, failed: 1, sent: 2, accepted: 3, delivered: 4, rejected: 5 }, scope: true

  validates :from_address, :to, :status, presence: true

  validate do
    if to.present? && !to.split(/[,;]/).all? { |dest| dest.match(/\A[^@\s]+@[^@\s]+\z/) }
      # TODO!: testear
      errors.add(:to, 'no es válido')
    end
  end

  validates :subject, length: { within: 0..200 }
  validates :from_name, length: { within: 0..80 }
  validates :to, length: { within: 3..200 }

  validates :body_input, presence: true, if: -> { require_body_input }

  validates :from_name, :subject, :to,
            format: { with: /\A[^\n<>&]*\z/, message: 'contiene caracteres inválidos' }

  after_initialize do
    self.from_address = ENV.fetch('DEFAULT_MAIL_FROM') if from_address.blank?
  end

  # validates_format_of :subject, with: /\A[[[:alpha:]]\(\)\w\s.,;!¡?¿-]+\z/

  def update_status!
    statuses = email_logs.map(&:status_for_email).compact

    # Aprovechando que los values de status están dispuestos de manera "cronologica"
    new_status = statuses.map { |st| Email.status.find_value(st).value }.max
    return unless new_status

    self.status = new_status
    return unless changed?

    self.audit_comment = 'Actualizando status desde logs'
    save!
  end
end

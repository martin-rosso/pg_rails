# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  apellido               :string           not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string           indexed
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  developer              :boolean          default(FALSE), not null
#  discarded_at           :datetime
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  nombre                 :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string           indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :lockable, :timeoutable, :trackable, :confirmable, :invitable

  audited
  include Discard::Model

  has_many :user_accounts, dependent: :destroy
  accepts_nested_attributes_for :user_accounts

  # Hace falta?
  has_many :accounts, through: :user_accounts

  # Crea automáticamente una user_account on create
  # a menos que ya exista en los nested attributes una user
  # account para la current tenant
  acts_as_tenant :account, through: :user_accounts

  has_many :notifications, as: :recipient, class_name: 'Noticed::Notification'

  validates :nombre, :apellido, presence: true

  validates_presence_of   :email
  validates_uniqueness_of :email, message: 'ya pertenece a un usuario'
  validates_format_of     :email, with: /\A[^@\s]+@[^@\s]+\z/
  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?, message: 'no coincide'
  validates_length_of       :password, if: :password_required?, within: 6..128,
                                       message: 'es demasiado corta (6 caracteres mínimo)'

  validates :accept_terms, acceptance: {
    message: 'Para crear una cuenta es necesario que aceptes los términos y condiciones'
  }

  before_invitation_created do
    user_accounts.first.membership_status = :invited
  end

  attr_accessor :orphan

  def active_for_authentication?
    super && kept?
  end

  # TODO: test
  def inactive_message
    kept? ? super : :locked
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # def remember_me
  #   true
  # end

  # DEPRECATED
  scope :query, ->(param) { where('email ILIKE ?', "%#{param}%") }

  ransacker :search do |parent|
    Arel::Nodes::InfixOperation.new(
      '||',
      Arel::Nodes::InfixOperation.new(
        '||',
        parent.table[:nombre], parent.table[:apellido]
      ),
      parent.table[:email]
    )
  end

  def to_s
    nombre_completo.strip.presence || email
  end

  def nombre_completo
    "#{nombre} #{apellido}"
  end

  class Error < PgEngine::Error; end

  def user_accounts_without_tenant
    ActsAsTenant.without_tenant do
      user_accounts.kept.where(membership_status: %i[active invited]).to_a
    end
  end

  def default_account
    raise Error, 'El usuario debe tener cuenta' if accounts.empty?

    user_accounts.first.account
    # throw :warden, scope: :user, message: :user_not_belongs_to_account
  end

  deprecate :current_account, deprecator: PgEngine.deprecator

  def current_account
    ActsAsTenant.current_tenant
  end

  def current_user_account
    if ActsAsTenant.current_tenant.nil?
      raise ActsAsTenant::Errors::NoTenantSet
    end

    user_accounts.kept.where(membership_status: :active)
                 .where(account: ActsAsTenant.current_tenant).first
  end

  delegate :profiles, to: :current_user_account
end

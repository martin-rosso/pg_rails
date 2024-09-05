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
         :lockable, :timeoutable, :trackable, :confirmable

  audited
  include Discard::Model

  has_many :user_accounts

  # Hace falta?
  has_many :accounts, through: :user_accounts

  # Para qué tener el tenant?
  # * Para el login en custom domains
  # * Para el listado de users en de admins de accounts
  #     no, para ese caso tiene que usar las user_accounts que siempre van tenanteadas
  # attr_accessor :account_id
  # acts_as_tenant :account, through: :user_accounts, optional: true
  # FIXME: poner la scope a mano

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

  attr_accessor :orphan

  after_create do
    # TODO: si fue invitado, sumar a la account del invitador
    create_account unless orphan
  end

  def create_account
    account = Account.create(nombre: email, plan: 0)
    ua = nil
    ActsAsTenant.with_tenant(account) do
      ua = user_accounts.create
    end
    raise(ActiveRecord::Rollback) unless ua&.persisted?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # def remember_me
  #   true
  # end

  scope :query, ->(param) { where('email ILIKE ?', "%#{param}%") }

  def to_s
    nombre_completo
  end

  def nombre_completo
    "#{nombre} #{apellido}"
  end

  class Error < PgEngine::Error; end

  def default_account
    # FIXME: hacer el account switcher
    raise Error, 'El usuario debe tener cuenta' if accounts.empty?

    user_accounts.first.account
    # throw :warden, scope: :user, message: :user_not_belongs_to_account
  end

  # FIXME: deprecar
  def current_account
    ActsAsTenant.current_tenant
    # account
    # raise Error, 'El usuario debe tener cuenta' if accounts.empty?

    # accounts.first
  end
end

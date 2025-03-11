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
  # Places where the default_scope applies:
  #  _  v  en los pg_associable inputs
  #  _  v  en los select de filtros de listados
  #     O  en los preload e includes de listados
  #     O  en los get de belongs_to
  default_scope lambda {
    if Current.namespace == :tenant
      if ActsAsTenant.unscoped?
        all
      else
        ids = Current.account.user_accounts.pluck(:user_id)

        # Es importante no hacer:
        # where(id: ids)
        # Ya que eso supone el riesgo de ser sobreescrita, por ejemplo
        # en el getter de un belongs_to
        # rubocop:disable Rails/WhereEquals
        where('users.id IN (?)', ids)
        # rubocop:enable Rails/WhereEquals
      end
    else
      all
    end
  }

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
  #
  # Es problemático porque interfiere en UserAccount.joins(:user)
  # y hace un doble join
  # acts_as_tenant :account, through: :user_accounts

  has_many :notifications, as: :recipient, class_name: 'Noticed::Notification'

  # validates :nombre, :apellido, presence: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [80, 80]
  end

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

  # When the user is invited via Devise Invitable
  before_invitation_created do
    user_accounts.first.invitation_status = :ist_invited
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
    nombre_completo_o_email
  end

  def nombre_completo_o_email
    nombre_completo.strip.presence || email
  end

  def nombre_completo
    "#{nombre} #{apellido}"
  end

  def first_first_name
    nombre.strip.split.first.presence || to_s
  rescue StandardError => e
    # :nocov:
    pg_warn(e)

    to_s
    # :nocov:
  end

  class Error < PgEngine::Error; end

  # def default_account
  #   raise Error, 'El usuario debe tener cuenta' if accounts.empty?

  #   user_accounts.first.account
  #   # throw :warden, scope: :user, message: :user_not_belongs_to_account
  # end

  deprecate :current_account, deprecator: PgEngine.deprecator

  def current_account
    ActsAsTenant.current_tenant
  end

  def active_user_account_for(account)
    user_account_for(account, active: true)
  end

  def user_account_for(account, active: false)
    if account.nil?
      # :nocov:
      raise PgEngine::Error, 'account must be present'
      # :nocov:
    end

    scope_name = active ? :ua_active : :kept

    ActsAsTenant.without_tenant do
      user_accounts.send(scope_name).where(account:).first
    end
  end
end

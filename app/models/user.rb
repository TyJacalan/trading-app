class User < ApplicationRecord
  has_many :transactions
  has_many :stocks
  has_many :wallets

  after_initialize :initialize_balance

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  enum role: { standard: 0, admin: 1 }
  enum approved: { false: 0, true: 1 }

  validates :first_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :last_name, length: { minimum: 2, maximum: 30 }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity

  scope :pending, -> { where(approved: [false, nil]) }
  scope :approved, -> { where(approved: true) }
  scope :admins, -> { where(role: 1) }
  scope :standards, -> { where(role: 0) }

  def password_complexity
    return unless password.present?

    errors.add(:password, 'cannot be longer than 128 characters') unless password.length <= 128
    errors.add(:password, 'must contain at least one letter') unless password.match?(/[a-zA-Z]/)
    errors.add(:password, 'must contain at least one number') unless password.match?(/\d/)
    return if password.match?(/[!@#$%^&*]/)

    errors.add(:password, 'must contain at least one special character')
  end

  private

  def initialize_balance
    self.balance ||= 0
  end
end

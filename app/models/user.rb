class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  enum role: { standard: 0, admin: 1 }

  validates :first_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :last_name, length: { minimum: 2, maximum: 30 }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity

  def password_complexity
    return unless password.present?

    errors.add(:password, 'cannot be longer than 128 characters') unless password.length <= 128
    unless password.match?(/[a-zA-Z]/)
      errors.add(:password, 'must contain at least one letter')
    end
    unless password.match?(/\d/)
      errors.add(:password, 'must contain at least one number')
    end
    unless password.match?(/[!@#$%^&*]/)
      errors.add(:password, 'must contain at least one special character')
    end
  end
end

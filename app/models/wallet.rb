class Wallet < ApplicationRecord
  belongs_to :user
  
  validates :balance, :currency, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: true

  def self.check_balance(balance, quantity)
    if balance < quantity
      raise StandardError, "Insufficient account balance."
    end
  end
end

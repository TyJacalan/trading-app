class Wallet < ApplicationRecord
  belongs_to :user
  enum transaction_type: { deposit: 0, withdraw: 1 }

  validates :transaction_type, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  scope :deposits, -> { where(transaction_type: :deposit) }
  scope :withdrawals, -> { where(transaction_type: :withdraw) }

  def self.deposit(user, amount)
    ActiveRecord::Base.transaction do
      wallet = user.wallets.create!(transaction_type: :deposit, amount: amount)

      # Update user account balance
      user.update(balance: user.balance + amount)

      { status: true, error: nil }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: false, error: e.message }
  end

  def self.withdraw(user, amount)
    ActiveRecord::Base.transaction do
      # Check user account balance
      unless user.balance >= amount
        raise StandardError, "Insufficient Account Balance"
      end

      wallet = user.wallets.create!(transaction_type: :withdraw, amount: amount)

      # Update user account balance
      user.update(balance: user.balance - amount)

      { status: true, error: nil }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: false, error: e.message }
  end
end

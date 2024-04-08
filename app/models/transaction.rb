class Transaction < ApplicationRecord
  include TransactionMethods

  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :amount, :currency, presence: true

  validate :validate_amount, if: -> { sell? }

  private

  def validate_amount
    return unless price && amount

    available_balance = stock_available_balance(symbol, user_id)
    errors.add :amount, 'cannot exceed available balance' if amount > available_balance
  end
end

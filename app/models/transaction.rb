class Transaction < ApplicationRecord
  include TransactionsConcern

  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :quantity, :currency, presence: true

  validate :validate_quantity, if: -> { sell? }

  private

  def validate_quantity
    return unless price && quantity

    available_balance = stock_available_balance(symbol, user_id)
    errors.add :quantity, 'cannot exceed available balance' if quantity > available_balance
  end
end

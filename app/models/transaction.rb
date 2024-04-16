class Transaction < ApplicationRecord
  include TransactionsConcern

  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :quantity, :currency, presence: true

  validate :validate_quantity, if: -> { sell? }

  scope :buys, -> { where(transaction_type: :buy) }
  scope :sells, -> { where(transaction_type: :sell) }
  scope :buy, ->(user_id) { where(transaction_type: :buy, user_id:) }
  scope :sell, ->(user_id) { where(transaction_type: :sell, user_id:) }
  scope :buy_by_symbol, ->(symbol, user_id) { where(symbol:, transaction_type: :buy, user_id:) }
  scope :sell_by_symbol, ->(symbol, user_id) { where(symbol:, transaction_type: :sell, user_id:) }
  scope :by_symbol, ->(symbol, user_id) { where(symbol:, user_id:) }

  private

  def validate_quantity
    return unless price && quantity

    available_balance = stock_available_balance(symbol, user_id)
    errors.add :quantity, 'cannot exceed available balance' if quantity > available_balance
  end
end

class Transaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :amount, :currency, presence: true

  validate :validate_amount, if: -> { transaction_type == 'sell' }

  def self.stock_available_balance(symbol, user_id)
    buy_balance = where(symbol:, transaction_type: :buy, user_id:).sum('price * amount')
    sell_balance = where(symbol:, transaction_type: :sell, user_id:).sum('price * amount')
    buy_balance - sell_balance
  end

  def self.aggregate_balance_by_symbol(user_id)
    buy_balances = Transaction.group(:symbol).where(user_id:, transaction_type: :buy).sum('price * amount')
    sell_balances = Transaction.group(:symbol).where(user_id:, transaction_type: :sell).sum('price * amount')

    aggregated_balances = {}

    buy_balances.each do |symbol, buy_balance|
      sell_balance = sell_balances[symbol] || 0
      aggregated_balances[symbol] = buy_balance - sell_balance
    end

    aggregated_balances
  end

  private

  def validate_amount
    return unless price && amount

    available_balance = Transaction.stock_available_balance(symbol, user_id)
    transaction_amount = price * amount
    return if transaction_amount <= available_balance

    errors.add :amount, 'cannot exceed available balance'
  end
end

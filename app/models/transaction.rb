class Transaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :amount, :currency, presence: true

  validate :validate_amount, if: -> { transaction_type == 'sell' }

  def self.stock_available_balance(symbol, user_id)
    buy_balance = where(symbol:, transaction_type: :buy, user_id:).sum('amount')
    sell_balance = where(symbol:, transaction_type: :sell, user_id:).sum('amount')
    buy_balance - sell_balance
  end

  def self.aggregate_balance_by_symbol(user_id)
    buy_balances = Transaction.group(:symbol).where(user_id:, transaction_type: :buy).sum('amount')
    sell_balances = Transaction.group(:symbol).where(user_id:, transaction_type: :sell).sum('amount')

    aggregated_balances = {}

    buy_balances.each do |symbol, buy_balance|
      sell_balance = sell_balances[symbol] || 0
      aggregated_balances[symbol] = buy_balance - sell_balance
    end

    aggregated_balances
  end

  def self.stock_price_average(symbol, user_id)
    price_total = Transaction.group(symbol).where(user_id).sum(&:price)
    price_total / price_total.Transaction.group(:symbol).where(user_id:).count
  end

  private

  def validate_amount
    return unless price && amount

    available_balance = Transaction.stock_available_balance(symbol, user_id)
    return if amount <= available_balance

    errors.add :amount, 'cannot exceed available balance'
  end
end

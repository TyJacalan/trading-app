class Transaction < ApplicationRecord

  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :quantity, presence: true

  validate :validate_quantity, if: -> { sell? }

  scope :buys, -> { where(transaction_type: :buy) }
  scope :sells, -> { where(transaction_type: :sell) }
  scope :buy, ->(user_id) { where(transaction_type: :buy, user_id:) }
  scope :sell, ->(user_id) { where(transaction_type: :sell, user_id:) }
  scope :buy_by_symbol, ->(symbol, user_id) { where(symbol:, transaction_type: :buy, user_id:) }
  scope :sell_by_symbol, ->(symbol, user_id) { where(symbol:, transaction_type: :sell, user_id:) }
  scope :by_symbol, ->(symbol, user_id) { where(symbol:, user_id:) }

  def self.aggregate_stocks_by_symbol(user_id)
    controller = ApplicationController.new
    client = controller.set_stock_api
    buy_transactions = Transaction.buy(user_id).group(:symbol).sum(:quantity)
    sell_transactions = Transaction.sell(user_id).group(:symbol).sum(:quantity)

    aggregated_stocks = []

    buy_transactions.each do |symbol, quantity|
      sales = sell_transactions[symbol] || 0
      stock_quantity = quantity - sales
      stock = client.quote(symbol)
      aggregated_stocks << {
        symbol: symbol,
        name: stock.company_name,
        change: stock.change_percent_s,
        quantity: stock_quantity,
        price_average: stock_price_average(symbol, user_id),
        price: stock.latest_price,
        value: stock.latest_price * stock_quantity
      }
    end

    aggregated_stocks
  end

  def self.stock_available_balance(symbol, user_id)
    controller = ApplicationController.new
    client = controller.set_stock_api
    stock = client.quote(symbol)
    buy_balance = Transaction.buy_by_symbol(symbol, user_id).sum("quantity * #{stock.latest_price}")
    sell_balance = Transaction.sell_by_symbol(symbol, user_id).sum("quantity * #{stock.latest_price}")
    buy_balance - sell_balance
  end

  private

  def validate_quantity
    return unless price && quantity

    available_balance = Transaction.stock_available_balance(symbol, user_id)
    puts "quantity: #{quantity}"
    puts "balance: #{available_balance}"
    errors.add :quantity, 'cannot exceed available balance' if quantity > available_balance
  end

  def self.stock_price_average(symbol, user_id)
    total_weighted_price = Transaction.by_symbol(symbol, user_id).sum('price * quantity')
    total_count = Transaction.by_symbol(symbol, user_id).count

    total_count.zero? ? 0 : total_weighted_price.to_d / total_count
  end

end

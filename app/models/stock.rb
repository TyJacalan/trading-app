class Stock < ApplicationRecord
  belongs_to :user

  validates :symbol, presence: true, uniqueness: true

  def self.find_or_create_stock(user, transaction)
    user.stocks.find_or_create_by(symbol: transaction.symbol, currency: transaction.currency)
  end

  def self.update_stock(stock, transaction)
    target_stock = find(stock.id)

    target_stock.quantity = calculate_quantity(stock, transaction)
    target_stock.price_avg = calculate_weighted_average_price(stock, transaction)

    target_stock.save
  end

  private

  def self.calculate_quantity(stock, transaction)
    if transaction.transaction_type == 'buy'
      stock.quantity += transaction.quantity
    elsif transaction.transaction_type == 'sell'
      if stock.quantity >= transaction.quantity
        stock.quantity -= transaction.quantity
      else
        raise StandardError, "Insufficient quantity to sell."
      end
    end

    stock.quantity
  end

  def self.calculate_weighted_average_price(stock, transaction)
    current_value = stock.price_avg * stock.quantity
    added_value = transaction.price * transaction.quantity
    total_quantity = stock.quantity + transaction.quantity

    new_value = (current_value + added_value) / total_quantity

    new_value
  end
end

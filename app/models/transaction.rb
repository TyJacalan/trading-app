class Transaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1 }

  validates :symbol, :transaction_type, :price, :quantity, :value, presence: true
  
  before_validation :calculate_value

  scope :buys, -> { where(transaction_type: :buy) }
  scope :sells, -> { where(transaction_type: :sell) }

  def self.buy(user, transaction_params)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.create!(transaction_params)
      stock = Stock.find_or_create_stock(user, transaction)
      Stock.update_stock(stock, transaction)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Transaction failed: #{e.message}"
    false
  end

  def self.sell(user, transaction_params)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.create!(transaction_params)
      stock = Stock.find_by(symbol: transaction.symbol, user_id: user.id)

      raise StandardError, "Stock not found" unless stock

      Stock.update_stock(stock, transaction)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Transaction failed: #{e.message}"
    false
  end

  private

  def calculate_value
    self.value = price * quantity
  end
end

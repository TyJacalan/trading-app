class Transaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: { buy: 0, sell: 1, deposit: 2, withdraw: 3 }

  validates :transaction_type, :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_value

  scope :buys, -> { where(transaction_type: :buy).order(created_at: :desc) }
  scope :sells, -> { where(transaction_type: :sell).order(created_at: :desc) }
  scope :purchases, -> { where(transaction_type: [:buy, :sell]) }
  scope :deposits, -> { where(transaction_type: :deposit) }
  scope :withdrawals, -> { where(transaction_type: :withdraw) }

  def self.buy(user, transaction_params)
    ActiveRecord::Base.transaction do

      transaction = user.transactions.create!(transaction_params)
      wallet = user.wallet

      stock = Stock.find_or_create_stock(user, transaction)
      Stock.update_stock(stock, transaction)
      
      Wallet.check_balance(wallet.balance, transaction.value)
      Wallet.update(balance: wallet.balance - transaction.value)

      { status: true, error: "" }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: false, error: e.message }
  end

  def self.sell(user, transaction_params)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.create!(transaction_params)
      wallet = user.wallet
      
      stock = Stock.find_by(symbol: transaction.symbol, user_id: user.id)
      raise StandardError, "Stock not in Portfolio" unless stock
      Stock.update_stock(stock, transaction)

      Wallet.update(balance: wallet.balance + transaction.value)

      { status: true, error: "" }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: false, error: e.message }
  end

  def self.deposit(user, transaction_params)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.create!(transaction_params)
      wallet = user.wallet

      Wallet.update(balance: wallet.balance + transaction.quantity)

      { status: true, error: "" }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: false, error: e.message }
  end

  def self.withdraw(user, transaction_params)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.create!(transaction_params)
      wallet = user.wallet

      Wallet.check_balance(wallet.balance, transaction.quantity)
      Wallet.update(balance: wallet.balance - transaction.quantity)

      { status: true, error: "" }
    end
  rescue ActiveRecord::RecordInvalid => e
    { status: false, error: e.message }
  end


  def self.calculate_gain(user)
    user.transactions.sells.sum(:value)
  end

  private

  def calculate_value
    if %w[deposit withdraw].include?(transaction_type)
      return if quantity.nil?
        self.value = quantity
    elsif %w[buy sell].include?(transaction_type)
      return if price.nil? || quantity.nil?
        self.value = price * quantity
    end
  end
end
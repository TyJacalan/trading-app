class Transaction < ApplicationRecord
  belongs_to :user
  enum transaction_type: { buy: 0, withdraw: 1 }

  validates :symbol, :transaction_type, :price, :amount, :currency, presence: true
end

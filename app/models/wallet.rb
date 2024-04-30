class Wallet < ApplicationRecord
  belongs_to :user
  
  validates :balance, :currency, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :user_id, uniqueness: true

  def self.check_balance(balance, quantity)
    if balance < quantity
      raise StandardError, "Insufficient account balance."
    end
  end

  def self.update_balance(user, transaction)
    wallet = user.wallet

    if transaction.transaction_type == 'deposit' || transaction.transaction_type == 'sell'
      wallet.update(balance: wallet.balance + transaction.value)
    elsif transaction.transaction_type == 'withdrawal' || transaction.transaction_type == 'buy'
      if transaction.amount < wallet.balance
      wallet.update(balance: wallet.balance - transaction.value)
      else
        raise StandardError, "Insufficient account balance." 
      end
    end
  end
end

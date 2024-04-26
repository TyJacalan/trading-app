class AddTransactionTypeAndAmountToWallets < ActiveRecord::Migration[7.1]
  def change
    add_column :wallets, :transaction_type, :integer
    add_column :wallets, :amount, :decimal
  end
end

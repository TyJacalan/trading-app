class RemoveBalanceFromWallet < ActiveRecord::Migration[7.1]
  def change
    remove_column :wallets, :balance, :decimal
  end
end

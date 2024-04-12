class ChangeAmountToQuantityInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :amount, :quantity
    change_column :transactions, :quantity, :integer
  end
end

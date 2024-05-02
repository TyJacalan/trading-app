class UpdateTransactionsTableNullValues < ActiveRecord::Migration[7.1]
  def change
    change_column_null :transactions, :symbol, true
    change_column_null :transactions, :price, true
  end
end

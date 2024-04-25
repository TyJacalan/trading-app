class AddValueToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :value, :decimal, precision: 15, scale: 8
  end
end

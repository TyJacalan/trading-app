class AddDefaultValuesToStocks < ActiveRecord::Migration[7.1]
  def change
    change_column :stocks, :quantity, :integer, default: 0
    change_column :stocks, :price_avg, :float, default: 0.0
  end
end

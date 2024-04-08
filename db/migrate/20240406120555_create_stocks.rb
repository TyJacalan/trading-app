class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.float :price_avg
      t.integer :quantity
      t.string :currency
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

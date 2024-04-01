class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.string :symbol,             null: false
      t.integer :transaction_type,  null: false
      t.decimal :price,             null: false, precision: 15, scale: 8
      t.decimal :amount,            null: false, precision: 15, scale: 8
      t.string :currency,           null: false
      t.references :user,           null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreateWallets < ActiveRecord::Migration[7.1]
    def change
    create_table :wallets do |t|
      t.integer :balance, null: false, default: 0.0
      t.string :currency, null: false, default: 'USD'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

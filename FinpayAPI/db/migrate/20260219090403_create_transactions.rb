class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :transaction_type, null: false
      t.string :status, null: false, default: "completed"

      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
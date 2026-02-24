class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.references :expense, null: false, foreign_key: true
      t.string :file_url
      t.decimal :amount

      t.timestamps
    end
  end
end

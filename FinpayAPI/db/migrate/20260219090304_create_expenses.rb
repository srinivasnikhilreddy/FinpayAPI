class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.text :description
      t.string :status, null: false, default: "pending"

      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
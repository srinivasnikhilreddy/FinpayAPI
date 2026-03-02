class CreateApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :approvals do |t|
      t.references :expense, null: false, foreign_key: true
      t.references :approver, null: false, foreign_key: { to_table: :users }

      t.string :status, null: false, default: "pending"

      t.timestamps
    end
  end
end
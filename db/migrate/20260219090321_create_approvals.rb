class CreateApprovals < ActiveRecord::Migration[7.0]
  def change
    create_table :approvals do |t|
      t.references :expense, null: false, foreign_key: true
      t.bigint :approver_id
      t.string :status

      t.timestamps
    end
  end
end

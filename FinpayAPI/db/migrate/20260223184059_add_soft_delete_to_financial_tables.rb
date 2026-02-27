class AddSoftDeleteToFinancialTables < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :deleted_at, :datetime
    add_column :accounts, :deleted_at, :datetime
    add_column :expenses, :deleted_at, :datetime
    add_column :approvals, :deleted_at, :datetime

    add_index :transactions, :deleted_at
    add_index :accounts, :deleted_at
    add_index :expenses, :deleted_at
    add_index :approvals, :deleted_at
  end
end
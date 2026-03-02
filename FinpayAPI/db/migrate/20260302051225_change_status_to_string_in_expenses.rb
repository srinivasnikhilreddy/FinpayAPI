class ChangeStatusToStringInExpenses < ActiveRecord::Migration[7.0]
  def change
    change_column :expenses, :status, :string, default: "pending", null: false
    add_index :expenses, :status
  end
end

class ChangeStatusToIntegerInExpenses < ActiveRecord::Migration[7.0]
  def change
    remove_column :expenses, :status
    add_column :expenses, :status, :integer, default: 0, null: false
  end
end

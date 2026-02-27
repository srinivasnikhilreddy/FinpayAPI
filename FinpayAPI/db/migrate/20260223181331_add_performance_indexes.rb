class AddPerformanceIndexes < ActiveRecord::Migration[7.0]
  def change
    # Approvals
    add_index :approvals, :status unless index_exists?(:approvals, :status)

    add_index :approvals,
              [:expense_id, :approver_id],
              unique: true,
              name: "index_approvals_on_expense_and_approver"

    # Expenses
    add_index :expenses, :status unless index_exists?(:expenses, :status)

    # Transactions
    add_index :transactions, :status unless index_exists?(:transactions, :status)
  end
end
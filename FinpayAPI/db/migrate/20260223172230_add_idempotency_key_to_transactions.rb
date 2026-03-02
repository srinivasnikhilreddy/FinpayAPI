class AddIdempotencyKeyToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :idempotency_key, :string
    add_index :transactions,
          [:idempotency_key, :account_id],
          unique: true,
          name: "index_transactions_on_idempotency_and_account"
  end
end
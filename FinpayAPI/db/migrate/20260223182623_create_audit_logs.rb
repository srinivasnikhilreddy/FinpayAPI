class CreateAuditLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_logs do |t|
      t.bigint :user_id
      t.string :action, null: false
      t.string :resource_type, null: false
      t.bigint :resource_id
      t.jsonb :metadata, default: {}
      t.string :ip_address
      t.string :request_id
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :audit_logs, :user_id
    add_index :audit_logs, [:resource_type, :resource_id]
    add_index :audit_logs, :action
    add_index :audit_logs, :created_at
  end
end
class AddDeviseFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    ## Database authenticatable
    add_column :users, :encrypted_password, :string, null: false, default: ""

    ## Recoverable
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    ## Rememberable
    add_column :users, :remember_created_at, :datetime

    ## JWT
    add_column :users, :jti, :string, null: false

    add_index :users, :reset_password_token, unique: true
    add_index :users, :jti, unique: true
  end
end
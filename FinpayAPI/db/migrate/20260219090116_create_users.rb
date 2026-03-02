class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :role, null: false, default: "employee"

      # Devise fields
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.string :jti, null: false, default: ""

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :jti, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
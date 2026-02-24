class AddUserToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :accounts, :user, null: false, foreign_key: true

    add_index :accounts, :user_id
  end
end
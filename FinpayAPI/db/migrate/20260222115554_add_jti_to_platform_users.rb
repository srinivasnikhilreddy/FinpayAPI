class AddJtiToPlatformUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_users, :jti, :string, null: false, default: ""
    add_index :platform_users, :jti, unique: true
  end
end
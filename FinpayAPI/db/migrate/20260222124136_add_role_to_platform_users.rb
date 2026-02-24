class AddRoleToPlatformUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :platform_users, :role, :string, null: false, default: "super_admin"
  end
end
class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :subdomain, null: false

      t.timestamps
    end

    add_index :companies, :subdomain, unique: true
  end
end

# This companies and platform_user in public schema.
# Other tables will be created in tenant schemas.
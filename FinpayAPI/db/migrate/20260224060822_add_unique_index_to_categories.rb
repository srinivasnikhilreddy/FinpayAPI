class AddUniqueIndexToCategories < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:accounts, :user_id)
      add_reference :accounts, :user, null: false, foreign_key: true
    end
  end
end
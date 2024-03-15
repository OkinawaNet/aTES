class AddAuthFieldsToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :provider
    remove_column :users, :uid
  end
end

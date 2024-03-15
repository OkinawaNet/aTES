class ChangeFieldsToUsers < ActiveRecord::Migration[7.1]
  def up
    change_column_null :users, :email, true
    add_column :users, :password, :string
  end

  def down
    change_column_null :users, :email, false
    remove_column :users, :password
  end
end

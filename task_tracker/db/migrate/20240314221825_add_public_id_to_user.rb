class AddPublicIdToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :public_id, :string
  end
end

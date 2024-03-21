class ChangePublicIdForTask < ActiveRecord::Migration[7.1]
  def up
    change_column_null :tasks, :public_id, false
  end

  def down
    change_column_null :tasks, :public_id, true
  end
end

class AddTitleToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :title, :string
  end
end

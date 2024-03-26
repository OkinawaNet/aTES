class AddDescriptionToTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :description, :string
  end
end

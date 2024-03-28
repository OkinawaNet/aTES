class AddJiraIdToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :jira_id, :string
  end
end

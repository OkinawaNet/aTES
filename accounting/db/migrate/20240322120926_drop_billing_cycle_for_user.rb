class DropBillingCycleForUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :billing_cycle_id
  end
end

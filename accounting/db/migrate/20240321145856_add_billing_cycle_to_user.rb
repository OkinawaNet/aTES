class AddBillingCycleToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :billing_cycle_id, :bigint
    add_column :users, :billing_cycle_period, :integer, null: false, default: 300
  end
end

class AddStateToBillingCycle < ActiveRecord::Migration[7.1]
  def change
    add_column :billing_cycles, :state, :string
  end
end

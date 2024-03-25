class RenameBillingPeriodForTransaction < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :billing_period, :billing_cycle_id
  end
end

class CreateBillingCycles < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_cycles do |t|
      t.datetime :start_at
      t.datetime :finish_at
      t.bigint :user_id, null: false

      t.timestamps
    end
  end
end

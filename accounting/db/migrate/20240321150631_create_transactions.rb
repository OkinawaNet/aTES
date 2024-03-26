class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.bigint :user_id
      t.string :description
      t.string :type
      t.integer :debit, null: false, default: 0
      t.integer :credit, null: false, default: 0
      t.integer :user_balance, null: false, default: 0
      t.uuid :public_id, null: false
      t.integer :task_id
      t.integer :billing_cycle_id, null: false

      t.timestamps
    end
  end
end

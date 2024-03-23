class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.integer :billing_period
      t.bigint :user_id
      t.string :description
      t.string :type
      t.integer :debit
      t.integer :credit
      t.integer :user_balance
      t.uuid :public_id
      t.integer :task_id

      t.timestamps
    end
  end
end

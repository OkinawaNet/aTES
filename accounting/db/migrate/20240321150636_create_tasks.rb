class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :state
      t.uuid :public_id
      t.bigint :user_id

      t.integer :assign_price, null: false, default: 0
      t.integer :close_price, null: false, default: 0

      t.timestamps
    end
  end
end

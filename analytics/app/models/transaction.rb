# == Schema Information
#
# Table name: transactions
#
#  id             :bigint           not null, primary key
#  billing_period :integer
#  user_id        :bigint
#  description    :string
#  type           :string
#  debit          :integer
#  credit         :integer
#  user_balance   :integer
#  public_id      :uuid
#  task_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Transaction < ApplicationRecord
end

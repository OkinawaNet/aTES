# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  description      :string
#  type             :string
#  debit            :integer          default(0), not null
#  credit           :integer          default(0), not null
#  user_balance     :integer          default(0), not null
#  public_id        :uuid             not null
#  task_id          :integer
#  billing_cycle_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :billing_cycle
  belongs_to :task

  before_create :set_public_id, :set_billing_cycle

  private

  def set_public_id
    self.public_id = SecureRandom.uuid
  end

  def set_billing_cycle
    self.billing_cycle = user.billing_cycles.open.last
  end
end

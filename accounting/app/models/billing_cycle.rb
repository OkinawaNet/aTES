# == Schema Information
#
# Table name: billing_cycles
#
#  id         :bigint           not null, primary key
#  start_at   :datetime
#  finish_at  :datetime
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string
#
class BillingCycle < ApplicationRecord
  belongs_to :user
  has_many :transactions

  before_create :set_start_at, :set_finish_at

  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }

  state_machine :state, initial: :open do
    event :close do
      transition open: :closed
    end
  end

  private

  def set_start_at
    current_datetime = DateTime.now
    self.start_at = current_datetime - (current_datetime.to_i % user.billing_cycle_period).seconds
  end

  def set_finish_at
    self.finish_at = self.start_at + (user.billing_cycle_period - 1).seconds
  end
end

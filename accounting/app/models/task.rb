# == Schema Information
#
# Table name: tasks
#
#  id           :bigint           not null, primary key
#  state        :string
#  public_id    :uuid
#  user_id      :bigint
#  assign_price :integer          default(0), not null
#  close_price  :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :user
  has_many :transactions

  before_create :set_assign_price, :set_close_price

  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }

  private

  def set_assign_price
    self.assign_price = Random.rand(10..20)
  end

  def set_close_price
    self.close_price = Random.rand(20..40)
  end
end

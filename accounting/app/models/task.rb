class Task < ApplicationRecord
  belongs_to :user
  has_many :transactions

  before_create :set_assign_price, :set_close_price

  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }

  state_machine :state, initial: :open

  private

  def set_assign_price
    self.assign_price = Random.rand(10..20)
  end

  def set_close_price
    self.close_price = Random.rand(20..40)
  end
end

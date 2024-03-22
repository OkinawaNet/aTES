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

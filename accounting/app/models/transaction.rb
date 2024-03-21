class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :billing_cycle
  has_one :task

  before_create :set_public_id, :set_billing_cycle

  private

  def set_public_id
    self.public_id = SecureRandom.uuid
  end

  def set_billing_cycle
    self.billing_cycle = BillingCycle.first_or_create(user: user)
  end
end

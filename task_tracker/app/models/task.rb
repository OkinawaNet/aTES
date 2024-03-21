class Task < ApplicationRecord
  belongs_to :user

  before_create :set_public_id

  scope :open, -> { where(state: :open) }

  state_machine :state, initial: :open do
    event :close do
      transition open: :closed
    end
  end

  private

  def set_public_id
    self.public_id = SecureRandom.uuid
  end
end

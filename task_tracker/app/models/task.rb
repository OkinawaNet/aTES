class Task < ApplicationRecord
  belongs_to :user
  before_create :set_public_id

  private

  def set_public_id
    self.public_id = SecureRandom.uuid
  end
end

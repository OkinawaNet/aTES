# == Schema Information
#
# Table name: tasks
#
#  id         :bigint           not null, primary key
#  state      :string
#  public_id  :uuid             not null
#  user_id    :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Task < ApplicationRecord
  belongs_to :user

  before_create :set_public_id
  after_create :broadcast

  scope :open, -> { where(state: :open) }

  state_machine :state, initial: :open do
    event :close do
      transition open: :closed
    end
  end

  def broadcast
    Karafka.producer.produce_async(
      topic: 'tasks-streaming',
      payload: {
        public_id: public_id,
        assigned_user_public_id: user.public_id,
        state: state
      }.to_json
    )
  end

  private

  def set_public_id
    self.public_id = SecureRandom.uuid
  end
end

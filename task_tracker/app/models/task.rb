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
  after_create :broadcast, :produce_task_assigned

  scope :open, -> { where(state: :open) }

  state_machine :state, initial: :open do
    event :close do
      transition open: :closed
    end
  end

  private

  def broadcast
    Karafka.producer.produce_async(
      topic: 'tasks-streaming',
      payload: {
        event: 'task_created',
        data: {
          public_id: public_id,
          assigned_user_public_id: user.public_id,
          state: state
        }
      }.to_json
    )
  end

  def produce_task_assigned
    Karafka.producer.produce_async(
      topic: 'tasks-workflow',
      payload: {
        event: 'task_assigned',
        data: {
          public_id: public_id,
          assigned_user_public_id: user.public_id
        }
      }.to_json
    )
  end

  def set_public_id
    self.public_id = SecureRandom.uuid
  end
end

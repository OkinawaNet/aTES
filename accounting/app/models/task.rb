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
#  description  :string
#
class Task < ApplicationRecord
  belongs_to :user
  has_many :transactions

  before_create :set_assign_price, :set_close_price
  # streaming
  after_update :produce_task_updated

  scope :open, -> { where(state: :open) }
  scope :closed, -> { where(state: :closed) }

  private

  def produce_task_updated
    Karafka.producer.produce_async(
      topic: 'tasks-streaming',
      payload: {
        event: 'task_updated',
        data: {
          public_id: public_id,
          assigned_user_public_id: user.public_id,
          state: state,
          close_price: close_price
        }
      }.to_json
    )
  end

  def set_assign_price
    self.assign_price = Random.rand(10..20)
  end

  def set_close_price
    self.close_price = Random.rand(20..40)
  end
end

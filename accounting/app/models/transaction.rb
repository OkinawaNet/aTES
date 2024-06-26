# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  description      :string
#  type             :string
#  debit            :integer          default(0), not null
#  credit           :integer          default(0), not null
#  user_balance     :integer          default(0), not null
#  public_id        :uuid             not null
#  task_id          :integer
#  billing_cycle_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :billing_cycle
  belongs_to :task, optional: true

  # streaming
  after_create :produce_transaction_applied

  before_create :set_public_id

  private

  def produce_transaction_applied
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_name: 'transaction_applied',
      event_time: DateTime.now.to_s,
      producer: 'accounting',
      data: {
        debit: debit,
        credit: credit,
        description: description,
        public_id: public_id,
        assigned_user_public_id: user.public_id,
        task_public_id: task&.public_id,
        billing_cycle_id: billing_cycle_id,
        user_balance: user_balance,
        created_at: created_at.to_s
      }
    }

    result = SchemaRegistry.validate_event(event, 'transactions-workflow.transaction_applied', version: 1)

    if result.success?
      Karafka.producer.produce_async(topic: 'transactions-workflow', payload: event.to_json)
    else
      Rails.logger.error(result.failure)
    end
  end

  def set_public_id
    self.public_id = SecureRandom.uuid
  end
end

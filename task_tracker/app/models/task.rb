# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  state       :string
#  public_id   :uuid             not null
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#  title       :string
#  jira_id     :string
#

class Task < ApplicationRecord
  belongs_to :user

  before_create :set_public_id
  before_save :parse_title

  # streaming
  after_create :produce_task_created

  after_update :produce_task_updated, if: :saved_changes?

  # workflow
  after_create :produce_task_assigned
  after_update :produce_task_assigned, if: :saved_change_to_user_id?
  after_update :produce_task_closed, if: :saved_change_to_state?

  scope :open, -> { where(state: :open) }

  state_machine :state, initial: :open do
    event :close do
      transition open: :closed
    end
  end

  private

  def produce_task_created
    if self.jira_id?
      produce_task_created_v2
    else
      produce_task_created_v1
    end
  end

  def produce_task_created_v1
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_name: 'task_created',
      event_time: DateTime.now.to_s,
      producer: 'task_tracker',
      data: {
        public_id: public_id,
        assigned_user_public_id: user.public_id,
        state: state,
        title: title,
        description: description
      }
    }

    result = SchemaRegistry.validate_event(event, 'tasks-streaming.task_created', version: 1)

    if result.success?
      Karafka.producer.produce_async(topic: 'tasks-streaming', payload: event.to_json)
    else
      Rails.logger.error(result.failure)
    end
  end

  def produce_task_created_v2
    event = {
      event_id: SecureRandom.uuid,
      event_version: 2,
      event_name: 'task_created',
      event_time: DateTime.now.to_s,
      producer: 'task_tracker',
      data: {
        public_id: public_id,
        assigned_user_public_id: user.public_id,
        state: state,
        jira_id: jira_id,
        title: title,
        description: description
      }
    }

    result = SchemaRegistry.validate_event(event, 'tasks-streaming.task_created', version: 2)

    if result.success?
      Karafka.producer.produce_async(topic: 'tasks-streaming', payload: event.to_json)
    else
      Rails.logger.error(result.failure)
    end
  end

  def produce_task_updated
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_name: 'task_updated',
      event_time: DateTime.now.to_s,
      producer: 'task_tracker',
      data: {
        public_id: public_id,
        assigned_user_public_id: user.public_id,
        state: state,
        description: description
      }
    }

    result = SchemaRegistry.validate_event(event, 'tasks-streaming.task_updated', version: 1)

    if result.success?
      Karafka.producer.produce_async(topic: 'tasks-streaming', payload: event.to_json)
    else
      Rails.logger.error(result.failure)
    end
  end

  def produce_task_assigned
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_name: 'task_assigned',
      event_time: DateTime.now.to_s,
      producer: 'task_tracker',
      data: {
        public_id: public_id,
        assigned_user_public_id: user.public_id
      }
    }

    result = SchemaRegistry.validate_event(event, 'tasks-workflow.task_assigned', version: 1)

    if result.success?
      Karafka.producer.produce_async(topic: 'tasks-workflow', payload: event.to_json)
    else
      Rails.logger.error(result.failure)
    end
  end

  def produce_task_closed
    event = {
      event_id: SecureRandom.uuid,
      event_version: 1,
      event_name: 'task_closed',
      event_time: DateTime.now.to_s,
      producer: 'task_tracker',
      data: {
        public_id: public_id,
        state: state
      }
    }

    result = SchemaRegistry.validate_event(event, 'tasks-workflow.task_closed', version: 1)

    if result.success?
      Karafka.producer.produce_async(topic: 'tasks-workflow', payload: event.to_json)
    else
      Rails.logger.error(result.failure)
    end
  end

  def set_public_id
    self.public_id = SecureRandom.uuid
  end

  def parse_title
    jira_regex = /\[(\w+)\]\s?(.*)/
    if match = self.title.match(jira_regex)
      self.jira_id = match[1]
      self.title = match[2]
    end
  end
end

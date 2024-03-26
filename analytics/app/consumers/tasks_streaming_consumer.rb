# frozen_string_literal: true

class TasksStreamingConsumer < ApplicationConsumer
  # delegate :logger, to: Rails
  def consume
    messages.each { |message| process_message(message) }
  end

  private

  def process_message(message)
    case message.payload['event']
    when 'task_created'
      on_task_created(message.payload['data'])
    when 'task_updated'
      on_task_updated(message.payload['data'])
    end
  end

  def on_task_created(data)
    assigned_user = User.find_by(public_id: data['assigned_user_public_id'])
    Task.find_or_create_by(public_id: data['public_id'], user: assigned_user, state: data['state'])
  end

  def on_task_updated(data)
    task = Task.find_by!(public_id: data['public_id'])
    assigned_user = User.find_by(public_id: data['assigned_user_public_id'])

    payload = {
      state: data['state'],
      user: assigned_user,
      close_price: data['close_price']
    }.compact

    task.update(payload)
  end
end

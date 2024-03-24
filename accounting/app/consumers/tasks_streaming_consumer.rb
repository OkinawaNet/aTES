# frozen_string_literal: true

class TasksStreamingConsumer < ApplicationConsumer
  # delegate :logger, to: Rails
  def consume
    messages.each { |message| process_message(message) }
  end

  private

  def process_message(message)
    data = message.payload['data']
    assigned_user = User.find_by(public_id: data['assigned_user_public_id'])
    Task.find_or_create_by(public_id: data['public_id'], user: assigned_user, state: data['state'])
  end
end

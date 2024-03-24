# frozen_string_literal: true

class TasksStreamingConsumer < ApplicationConsumer
  # delegate :logger, to: Rails
  def consume
    messages.each { |message| process_message(message.payload) }
  end

  private

  def process_message(payload)
    assigned_user = User.find_by(public_id: payload['assigned_user_public_id'])
    Task.find_or_create_by(public_id: payload['public_id'], user: assigned_user, state: payload['state'])
  end
end

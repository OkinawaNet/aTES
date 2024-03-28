# frozen_string_literal: true

class TransactionsWorkflowConsumer < ApplicationConsumer
  def consume
    messages.each { |message| process_message(message) }
  end

  private

  def process_message(message)
    case message.payload['event_name']
    when 'transaction_created'
      on_transaction_created(message.payload['data'])
    end
  end

  def on_transaction_created(data)
    task = Task.find_by!(public_id: data['task_public_id'])
    assigned_user = User.find_by!(public_id: data['assigned_user_public_id'])

    payload = {
      debit: data['debit'],
      credit: data['credit'],
      description: data['description'],
      public_id: data['public_id'],
      user: assigned_user,
      task: task,
      billing_cycle_id: data['billing_cycle_id'],
      user_balance: data['user_balance'],
      created_at: data['created_at']
    }.compact

    Transaction.create(payload)

    assigned_user.update(balance: data['user_balance'])
  end

  def get_user_balance(user)
    user.transactions.last&.user_balance || 0
  end
end

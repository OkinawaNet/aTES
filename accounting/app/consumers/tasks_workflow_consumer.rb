# frozen_string_literal: true

class TasksWorkflowConsumer < ApplicationConsumer
  def consume
    messages.each { |message| process_message(message) }
  end

  private

  def process_message(message)
    data = message.payload['data']

    if task = Task.find_by!(public_id: data['public_id'])
      create_assign_user_transaction(task, User.find_by(public_id: data['assigned_user_public_id']))
    end
  end

  def create_assign_user_transaction(task, assigned_user)
    new_balance = get_user_balance(assigned_user) - task.assign_price

    Transaction.create(
      task: task,
      user: assigned_user,
      credit: task.assign_price,
      billing_cycle: assigned_user.billing_cycles.open.last,
      user_balance: new_balance
    )

    assigned_user.update(balance: new_balance)
  end

  def get_user_balance(user)
    user.transactions.last&.user_balance || 0
  end
end

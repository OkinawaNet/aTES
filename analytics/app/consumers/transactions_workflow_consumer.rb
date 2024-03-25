# frozen_string_literal: true

class TransactionsWorkflowConsumer < ApplicationConsumer
  def consume
    messages.each { |message| process_message(message) }
  end

  private

  def process_message(message)
    case message.payload['event']
    when 'transaction_created'
      on_transaction_created(message.payload['data'])
    end
  end

  def on_transaction_created(data)
    if task = Task.find_by!(public_id: data['public_id'])
      assigned_user = User.find_by!(public_id: data['assigned_user_public_id'])

      task.update(user: assigned_user)

      create_assign_user_transaction(task, assigned_user)
    end
  end

  def on_task_closed(data)
    if task = Task.find_by!(public_id: data['public_id'])
      task.update(state: data['state'])

      create_task_closed_transaction(task, task.user)
    end
  end

  def create_assign_user_transaction(task, assigned_user)
    new_balance = get_user_balance(assigned_user) - task.assign_price

    Transaction.create(
      task: task,
      user: assigned_user,
      description: 'Task assigned',
      credit: task.assign_price,
      billing_cycle: assigned_user.billing_cycles.open.last,
      user_balance: new_balance
    )

    assigned_user.update(balance: new_balance)
  end

  def create_task_closed_transaction(task, assigned_user)
    new_balance = get_user_balance(assigned_user) + task.close_price

    Transaction.create(
      task: task,
      user: assigned_user,
      description: 'Task closed',
      debit: task.close_price,
      billing_cycle: assigned_user.billing_cycles.open.last,
      user_balance: new_balance
    )

    assigned_user.update(balance: new_balance)
  end

  def get_user_balance(user)
    user.transactions.last&.user_balance || 0
  end
end

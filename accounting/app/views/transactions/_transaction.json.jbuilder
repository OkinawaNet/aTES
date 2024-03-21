json.extract! transaction, :id, :billing_period, :user_id, :description, :type, :debit, :credit, :user_balance, :public_id, :task_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)

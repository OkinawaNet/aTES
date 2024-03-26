json.extract! task, :id, :state, :public_id, :user_id, :created_at, :updated_at
json.url task_url(task, format: :json)

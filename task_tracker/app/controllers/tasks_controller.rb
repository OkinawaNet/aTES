class TasksController < ApplicationController
  before_action :set_task, only: %i[close]
  before_action :set_users, only: %i[new]

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all.order({state: :desc, id: :desc})
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_url, notice: "Task was successfully created." }
        format.json { render :index }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def close
    @task.close!
  end

  def assign_tasks
    shuffle(Task.open, User.with_role(:popug))
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def set_users
    @users = User.with_role(:popug)
  end

  def task_params
    params.require(:task).permit(:user_id, :description)
  end

  def shuffle(tasks, users)
    tasks.each do |task|
      task.update(user: users.sample)
    end
  end
end

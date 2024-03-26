class StatsController < ApplicationController
  before_action :set_closed_task_all, only: :index
  before_action :set_closed_task_five, only: :index
  before_action :set_bankrupts, only: :index

  def index
  end

  def set_closed_task_all
    @closed_task_all = Task.closed.order(close_price: :desc).first
  end

  def set_closed_task_five
     @closed_task_five = Task.closed.where(created_at: 5.minutes.ago..).order(close_price: :desc).first
  end

  def set_bankrupts
    @bankrupts = User.where(balance: ..-1)
  end
end

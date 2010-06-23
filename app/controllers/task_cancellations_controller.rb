
class TaskCancellationsController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    @task.cancelled!
    flash[:notice] = "Task was successfully cancelled."
    redirect_to @task
  end
end

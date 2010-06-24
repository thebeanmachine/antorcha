
class TaskMessagesController < ApplicationController
  def index
    @task = Task.find(params[:task_id])
    @search = @task.messages.search(params[:search])
    @messages = @search.all
    render :template => 'messages/index'
  end

  def new
    @task = Task.find(params[:task_id])
    @instructions_to_start_with = @task.procedure.instructions.to_start_with.all
    @message = Message.new
  end
  
  def create
    @task = Task.find(params[:task_id])
    @message = @task.messages.new(params[:message])
    if @message.save
      redirect_to(@message, :notice => t('notice.created', :model => 'Message'))
    else
      render :action => "new"
    end
  end
end

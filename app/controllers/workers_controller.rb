class WorkersController < ApplicationController
  authorize_resource

  after_filter :push_statistics, :except => :index
  
  def index
    @workers = Worker.all
  end

  def create
    Worker.start
    redirect_to workers_url
  end
  
  def destroy
    Worker.all.each do |worker|
      if worker.to_param == params[:id]
        worker.stop
      end
    end
    redirect_to workers_url
  end

private
  def push_statistics
    Statistic.push
  end

end


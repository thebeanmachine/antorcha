class WorkersController < ApplicationController
  
  load_and_authorize_resource
  
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
  
end


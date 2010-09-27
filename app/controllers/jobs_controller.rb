class JobsController < ApplicationController
  def index
    @jobs = Delayed::Job.all :order => "delayed_jobs.run_at DESC"
  end
  
  def retry
    Delayed::Job.find(params[:id]).update_attributes :run_at => Time.now, :attempts => 0, :failed_at => nil
    redirect_to jobs_url
  end
end

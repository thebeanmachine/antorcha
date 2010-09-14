class JobsController < ApplicationController
  def index
    @jobs = Delayed::Job.all :order => "delayed_jobs.run_at DESC"
  end
end

class StartStepsController < ApplicationController
  def index
    @steps = Step.to_start_with

    respond_to do |format|
      format.html { render :template => 'steps/index' }
      format.xml  { render :xml => @steps }
    end
  end
end

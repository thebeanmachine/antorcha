class StartInstructionsController < ApplicationController
  def index
    @instructions = Instruction.to_start_with

    respond_to do |format|
      format.html { render :template => 'instructions/index' }
      format.xml  { render :xml => @instructions }
    end
  end
end

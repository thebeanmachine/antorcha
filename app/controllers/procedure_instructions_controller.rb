class ProcedureInstructionsController < ApplicationController
  def index
    @procedure = Procedure.find(params[:procedure_id])
    @instructions = @procedure.instructions
  end
  
  def new
    @instruction = Instruction.new
    @procedure = Procedure.find(params[:procedure_id])
  end

  def create
    @procedure = Procedure.find(params[:procedure_id])
    @instruction = @procedure.instructions.new(params[:instruction])

    if @instruction.save
      redirect_to @instruction, :notice => 'Instruction created successfully.'
    else
      render :action => "new"
    end
  end
end
class ProcedureInstructionsController < ApplicationController
  def new
    @instruction = Instruction.new
    @procedure = Procedure.find(params[:procedure_id])
  end

  def create
    @procedure = Procedure.find(params[:procedure_id])
    @instruction = @procedure.instructions.new(params[:instruction])

    if @instruction.save
      redirect_to @instruction, :notice => 'Stap succesvol aangemaakt.'
    else
      render :action => "new"
    end
  end
end
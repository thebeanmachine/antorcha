class InstructionsController < ApplicationController
  # GET /instructions
  # GET /instructions.xml
  def index
    @instructions = Instruction.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instructions }
    end
  end

  def show
    @instruction = Instruction.find(params[:id])
    @procedure = @instruction.procedure

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @instruction }
    end
  end

  def edit
    @instruction = Instruction.find(params[:id])
    @procedure = @instruction.procedure
  end

  def update
    @instruction = Instruction.find(params[:id])

    respond_to do |format|
      if @instruction.update_attributes(params[:instruction])
        format.html { redirect_to(@instruction, :notice => 'Instruction was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instruction.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @instruction = Instruction.find(params[:id])
    @instruction.destroy

    redirect_to(procedure_url(@instruction.procedure))
  end
end

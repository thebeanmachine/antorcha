class TransactionRolesController < ApplicationController
  
  def index
    @transaction_roles = TransactionRole.all
  end

  def show
    @transaction_role = TransactionRole.find(params[:id])
  end

  def new
    @transaction_role = TransactionRole.new
  end

  def edit
    @transaction_role = TransactionRole.find(params[:id])
  end

  def create
    @transaction_role = TransactionRole.new(params[:transaction_role])

    if @transaction_role.save
      redirect_to(@transaction_role, :notice => 'TransactionRole was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @transaction_role = TransactionRole.find(params[:id])

    if @transaction_role.update_attributes(params[:transaction_role])
      redirect_to(@transaction_role, :notice => 'TransactionRole was successfully updated.')
    else
      render :action => "edit"
    end
 end

  def destroy
    @transaction_role = TransactionRole.find(params[:id])
    @transaction_role.destroy
    redirect_to(transaction_roles_url)
  end
end

class RolesController < ApplicationController
  
  def index
    @roles = Role.all
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      redirect_to(@role, :notice => 'Role was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      redirect_to(@role, :notice => 'Role was successfully updated.')
    else
      render :action => "edit"
    end
 end

  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    redirect_to(roles_url)
  end
end

class RolesController < ApplicationController
  load_and_authorize_resource :nested => :definition
  
  def index
    @roles = @definition.roles
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @role.save
      redirect_to [@definition, @role], :notice => 'Role was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    if @role.update_attributes(params[:role])
      redirect_to [@definition, @role], :notice => 'Role was successfully updated.'
    else
      render :action => "edit"
    end
 end

  def destroy
    @role.destroy
    redirect_to definition_roles_url(@definition) 
  end
end

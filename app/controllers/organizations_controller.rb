class OrganizationsController < ApplicationController
  
  def index
    @organizations = Organization.all
  end

  def show
    @organization = Organization.find(params[:id])
  end

  def new
    @organization = Organization.new
  end

  def edit
    @organization = Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(params[:organization])
    unless params[:transaction_role].blank?
      @organization.transaction_roles.new(params[:transaction_role])
    end

    if @organization.save
      redirect_to(@organization, :notice => 'Organization was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @organization = Organization.find(params[:id])

    if @organization.update_attributes(params[:organization])
      redirect_to(@organization, :notice => 'Organization was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @organization = Organization.find(params[:id])
    @organization.destroy

    redirect_to(organizations_url)    
  end

private
  
  def hoi
    
  end
end

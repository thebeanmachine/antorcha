class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.all
    render :xml => @organizations
  end

  def show
    @organization = Organization.find(params[:id])
    render :xml => @organization.to_xml(:only => [:id, :name])
  end

end

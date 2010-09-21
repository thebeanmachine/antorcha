class ProcessingsController < ApplicationController
  
  authorize_resource
  
  def index
    @processings = Processing.all
  end

end

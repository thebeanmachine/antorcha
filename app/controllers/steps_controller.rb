class StepsController < ApplicationController
  def index
    @steps = Message.find(params[:message_id]).effect_steps :name => params[:name] if params[:message_id]
    @steps ||= Step.all
    render :xml => @steps
  end
end

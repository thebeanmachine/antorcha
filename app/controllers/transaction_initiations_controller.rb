#
# Maak een transactie + een eerste stap.
#
#
#
class TransactionInitiationsController < ApplicationController
  load_and_authorize_resource :name => :transaction
  before_filter :find_starting_steps
  
  def new
    flash[:notice] = "Er zijn geen startstappen voor u." if @starting_steps.empty?
  end
  
  def create
    @transaction.initialized_at = DateTime.now    
    @transaction.validate_initiation
    unless @transaction.errors.blank?
      render :action => :new
      # render :text => @transaction.errors.full_messages
    else
      @step = Step.find @transaction.starting_step
      @message = create_transaction_and_message @transaction, @step
      redirect_to edit_message_url(@message), :notice => 'Transactie succesvol aangemaakt.'
    end
  end
  
private
  def find_starting_steps
    @starting_steps = Step.starting_steps :user => current_user
  end

  module TransactionInitiationMixin
    def create_transaction_and_message transaction, starting_step
      transaction.definition = starting_step.definition
    
      transaction.save
      transaction.update_uri url_for(transaction)

      message = transaction.messages.build :step => starting_step
      message.save
      message
    end
  end
  
  include TransactionInitiationMixin
  
end
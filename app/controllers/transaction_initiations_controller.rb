#
# Maak een transactie + een eerste stap.
#
#
#
class TransactionInitiationsController < ApplicationController
  load_and_authorize_resource :name => :transaction
  before_filter :find_starting_steps
  
  def new
  end
  
  def create
    @transaction.validate_initiation
    unless @transaction.errors.blank?
      render :action => :new
    else
      create_transaction_and_message
      redirect_to edit_message_url(@message), :notice => 'Transactie succesvol aangemaakt.'
    end
  end
  
private
  def find_starting_steps
    @starting_steps = Step.to_start_with.all
  end
  
  def create_transaction_and_message
    @step = Step.find @transaction.starting_step

    @transaction.definition = @step.definition
    
    @transaction.save
    @transaction.update_uri url_for(@transaction)

    @message = @transaction.messages.build :step => @step
    @message.save
  end
  
end
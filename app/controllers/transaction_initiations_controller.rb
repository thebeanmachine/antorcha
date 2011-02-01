#
# Maak een transactie + een eerste stap.
# Maar dat is nog niet alles hoor... want we maken ook direct een bericht.... 
#
#
class TransactionInitiationsController < ApplicationController
  load_and_authorize_resource :name => :transaction
  before_filter :find_starting_steps
  
  def new
    flash[:error] = "Helaas, u kunt nu geen berichten versturen. De transactiedefinities konden niet opgehaald worden." 
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

      message = transaction.messages.build(:step => starting_step, :user => current_user)      
      message.save
      message
    end
  end
  
  include TransactionInitiationMixin
  
end
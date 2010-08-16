class TransactionService < AuthenticatedService
  include TransactionInitiationsController::TransactionInitiationMixin
  web_service_api TransactionAPI

  #def show token, transaction_id
  #end
  
  def initiate token, api_step
    begin
      @step = Step.find(api_step.id)
    rescue ActiveResource::ResourceNotFound
      raise TransactionServiceError, "Step #{api_step.id} not found"
    end
    
    @transaction = Transaction.new
    create_transaction_and_message @transaction, @step
  end
  
  #def index
  #  Transaction.all
  #end
  
private

  class TransactionServiceError < StandardError
  end
end

class TransactionService < ActionWebService::Base
  include TransactionInitiationsController::Smurf
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

  def initialize controller
    @controller = controller
  end

  def url_for *options
    @controller.url_for *options
  end

  
  class TransactionServiceError < StandardError
  end
end

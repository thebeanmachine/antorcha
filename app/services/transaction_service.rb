class TransactionService < ActionWebService::Base
  include TransactionInitiationsController::Smurf
  web_service_api TransactionAPI

  before_invocation :check_token

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
  
  
  def check_token method_name, args
    token = args[0]
    return [false, "No token specified"] unless token
    unless token.username == 'aap' and token.password == 'noot'
      return [false, "Access denied"]
    end
  end

  
  class TransactionServiceError < StandardError
  end
end

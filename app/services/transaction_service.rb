class TransactionService < ActionWebService::Base
  include TransactionInitiationsController::Smurf
  web_service_api TransactionAPI

  def put
  end

  def get
  end
  
  def initiate token
  end
  
  def index
    Transaction.all
  end
end

class TransactionService < ActionWebService::Base
  web_service_api TransactionAPI

  def put
  end

  def get
  end
  
  def index
    Transaction.all
  end
end

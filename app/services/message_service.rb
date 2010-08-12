class MessageService < ActionWebService::Base
  web_service_api MessageAPI

  def put
  end

  def get
  end
  
  def index
    Message.all
  end
end



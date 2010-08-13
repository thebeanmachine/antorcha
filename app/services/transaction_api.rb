
class TransactionAPI < ActionWebService::API::Base
  api_method :initiate, :expects => [Api::Token, Api::Step], :returns => [Api::Message]
  #api_method :show, :expects => [Api::Token, :int], :returns => [Api::Transaction]
end

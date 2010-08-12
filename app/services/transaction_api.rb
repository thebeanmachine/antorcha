
class TransactionAPI < ActionWebService::API::Base
  api_method :create, :expects => [:string], :returns => [:boolean]
  api_method :show, :expects => [:int], :returns => [Api::Transaction]
  api_method :index, :returns => [[Api::Transaction]]
end

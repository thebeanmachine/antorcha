
class MessageAPI < ActionWebService::API::Base
  api_method :create, :expects => [:string], :returns => [:boolean]
  api_method :show, :expects => [:int], :returns => [Api::Message]
  api_method :index, :returns => [[Api::Message]]
end

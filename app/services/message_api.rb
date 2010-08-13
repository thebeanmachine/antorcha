
class MessageAPI < ActionWebService::API::Base
  api_method :create, :expects => [Api::Token, :string], :returns => [:boolean]
  api_method :show, :expects => [Api::Token, :int], :returns => [Api::Message]
  api_method :index, :expects => [Api::Token], :returns => [[Api::Message]]
end

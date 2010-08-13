class SoapController < ApplicationController
  web_service_dispatching_mode :layered
  web_service(:message) { MessageService.new }
  web_service(:transaction) { TransactionService.new(self) }
  wsdl_namespace 'http://antorcha.nl/soap/v1/'
  web_service_scaffold :invoke if Rails.env.test? or Rails.env.development?


end

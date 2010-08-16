class SoapController < ApplicationController
  skip_before_filter :authenticate_user!

  web_service_dispatching_mode :layered

  web_service(:message) { MessageService.new(self) }
  web_service(:transaction) { TransactionService.new(self) }
  web_service(:step) { StepService.new(self) }

  wsdl_namespace 'http://antorcha.nl/soap/v1/'
  web_service_scaffold :invoke if Rails.env.test? or Rails.env.development?
end

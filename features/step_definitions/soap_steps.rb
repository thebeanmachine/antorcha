When /^I execute the SOAP script$/ do
  #Beetje vreemde eend in de bijt, maar zo kunnen we soap automatisch testen
  require 'soap/wsdlDriver'

  #always working soap request
  # wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
  # driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
  # response =  driver.IsValidISBN13(:sISBN => '9780393068474')
  # puts response.isValidISBN13Result
  # 
  # wsdl = 'http://localhost:3000/soap/wsdl'
  # 
  # driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
  # puts driver.Initiate({:username=>"wsdl",:password=>"asdfasdf"},{:title=>'Melding aan VIS2',:id=>6}) #OK
  # driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "MessagePort")
  # 20.times do 
  #   start = Time.now
  #   puts driver.IndexOutbox({:username=>"wsdl",:password=>"asdfasdf"}) #OK
  #   puts Time.now - start
  # end

  #puts driver.Show({:username=>"wsdl",:password=>"asdfasdf"},38).body # "asdfasdf" #OK
  #puts driver.Update({:username=>"wsdl",:password=>"asdfasdf"},{:step_id=>6,:body=>"My first WSDL created body",:transaction_id=>30,:title=>"VIS2 #41",:id=>41})
  #puts driver.Deliver({:username=>"wsdl",:password=>"asdfasdf"},{:step_id=>6,:body=>"My first WSDL created body",:transaction_id=>30,:title=>"VIS2 #41",:id=>20})
  
  def stopwatch &block
    start = Time.now
    yield
    puts Time.now - start
  end
  
  require 'savon'
  client = Savon::Client.new "http://localhost:3000/soap/wsdl"

  20.times do
    stopwatch do
      client.initiate do |zeep|
        zeep.body = {
          :token => {:username=>"wsdl",:password=>"asdfasdf"},
          :step => {:title=>'Melding aan VIS2',:id=>6}
        }
      end
    end

    stopwatch do
      client.index_outbox do |zeep|
        zeep.body = {
          :token => {:username=>"wsdl",:password=>"asdfasdf"},
        }
      end
    end
  end
end

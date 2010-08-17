When /^I execute the SOAP script$/ do
  #Beetje vreemde eend in de bijt, maar zo kunnen we soap automatisch testen
  require 'soap/wsdlDriver'

  wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
  driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

  # Log SOAP request and response
  driver.wiredump_file_base = "soap-log.txt"

  response =  driver.IsValidISBN13(:sISBN => '9780393068474')
  #pp(response)
  puts response.isValidISBN13Result

  wsdl = 'http://localhost:3000/soap/wsdl'

  driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

  20.times do 
    start = Time.now
    driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
    puts driver.Initiate({:username=>"wsdl",:password=>"asdfasdf"},{:title=>'Melding aan VIS2',:id=>6}) #OK
    driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "MessagePort")
    puts driver.IndexOutbox({:username=>"wsdl",:password=>"asdfasdf"}) #OK
    puts Time.now - start
  end

  #puts driver.Show({:username=>"wsdl",:password=>"asdfasdf"},38).body # "asdfasdf" #OK
  #puts driver.Update({:username=>"wsdl",:password=>"asdfasdf"},{:step_id=>6,:body=>"My first WSDL created body",:transaction_id=>30,:title=>"VIS2 #41",:id=>41})
  #puts driver.Deliver({:username=>"wsdl",:password=>"asdfasdf"},{:step_id=>6,:body=>"My first WSDL created body",:transaction_id=>30,:title=>"VIS2 #41",:id=>20})

  #.inspect #FAIL
end

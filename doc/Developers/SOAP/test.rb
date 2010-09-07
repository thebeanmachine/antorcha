#Requires Ruby version 1.8.5 or highet
require 'soap/wsdlDriver'

#Even testen of SOAP werkt in de basis (uitvoer dient te beginnen met true) 
wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
response =  driver.IsValidISBN13(:sISBN => '9780393068474')
puts response.isValidISBN13Result #true


#De wsdl url voor zorgaanbieder
wsdl = 'http://zorgaanbieder.thebeanmachine.nl/soap/wsdl'

driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver

# Log SOAP request and response
driver.wiredump_file_base = "soap-log.txt"
lastMessageId = nil
2.times do 
  #Beetje stress testen (2 kan opgehoogd worden naar ieder getal... loopt de outbox wel vol!)
  start = Time.now #we houden de tijd bij
  driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
  #Maak een nieuwe melding aan
  message = driver.Initiate({:username=>"maarten",:password=>"asdfasdf"},{:title=>'Maarten test Soap voor Richard aan VIS2',:id=>6}) #OK
  lastMessageId = message.id
  puts message.id
  driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "MessagePort")
  #Geef de objecten in de outbox weer
  puts driver.IndexOutbox({:username=>"maarten",:password=>"asdfasdf"}) #OK
  puts Time.now - start #tijd die hij hierover deed
end

#En om nog wat extra testjes te doen
driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "MessagePort")

#Geef een bericht body weer:
puts driver.Show({:username=>"maarten",:password=>"asdfasdf"},38).body # "asdfasdf" #OK

#Verander de body van een bericht (let hierbij op dat :id goed is, rest maakt eigenlijk niet zo veel uit)
message = driver.Update({:username=>"maarten",:password=>"asdfasdf"},{:step_id=>6,:body=>"My first WSDL created body",:transaction_id=>30,:title=>"Maarten test Soap voor Richard aan VIS2",:id=>lastMessageId})
puts message

#Verstuur een bericht (let hierbij op dat :id goed is, rest maakt eigenlijk niet zo veel uit, maar iig de rails soap client vereist wel dat het mee wordt gestuurd)

driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver(nil, "MessagePort")

# Dit laatste geeft bij mij voorlopig nog een foutmelding "RuntimeError: Don't know how to cast TrueClass to Api::Message"
puts driver.Deliver({:username=>"maarten",:password=>"asdfasdf"},{:step_id=>6,:body=>"My first WSDL created body",:transaction_id=>30,:title=>"VIS2 #41",:id=>lastMessageId})
puts driver.Deliver({:username=>"maarten",:password=>"asdfasdf"},message)


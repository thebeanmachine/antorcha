 require 'soap/wsdlDriver' 

 ZORGAANBIEDER = 'http://henk:qwerty@localhost:3000/soap/wsdl' # Pas dit aan voor je test!

 def stresstest(number, username, password)     
   @title = "Start 'deliverMessageAfterInitTransaction' SOAP-call stresstest with #{number} calls."
   p @title

   number.times do |i|
     p "-" * @title.size
     p "Request #{i+1}: "
     deliverMessageAfterInitTransaction("snelverzonden","<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>tadu tadu tadu</melding>",ZORGAANBIEDER, username, password)
     p @message.body
     p "Finished!"
   end   
 end
 
 def deliverMessageAfterInitTransaction(titel, body, endpoint, username, password)
   step = startSteps(endpoint, username, password).first
   driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
   @message = driver.DeliverMessageAfterInitTransaction({:username=>username,:password=>password},step,titel,body)
 end
 
 def startSteps(endpoint, username, password)
   driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
   steps = driver.StartingStepsIndex({:username=>username,:password=>password}) #OK
   steps
end
 
 stresstest 11, "henk", "qwerty" # Pas dit aan voor je test!
    require 'soap/wsdlDriver'

    def startTransaction(step)
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver
      transaction = driver.Initiate({:username=>"maarten",:password=>"asdfasdf"},step) #OK
      transaction
    end

    def deliver(message)
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      return driver.Deliver({:username=>"maarten",:password=>"asdfasdf"},message)
    end


    def updateMessage(message)
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      message = driver.Update({:username=>"maarten",:password=>"asdfasdf"},message)
    end

    def index
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      driver.Index({:username=>"maarten",:password=>"asdfasdf"}) #OK
    end

    def indexRead
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      driver.IndexRead({:username=>"maarten",:password=>"asdfasdf"}) #OK
    end

    def startSteps()
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "StepPort")
      steps = driver.StartingStepsIndex({:username=>"maarten",:password=>"asdfasdf"}) #OK
      steps
    end

    def showMessage(id)
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      driver.Show({:username=>"maarten",:password=>"asdfasdf"},id) # "asdfasdf" #OK
    end

    def deleteMessage(message)
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      driver.Delete({:username=>"maarten",:password=>"asdfasdf"},message) # "asdfasdf" #OK
    end

    def testSoap
      #Even testen of SOAP werkt in de basis (uitvoer dient te beginnen met true) 
      wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
      driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
      response =  driver.IsValidISBN13(:sISBN => '9780393068474')
      puts response.isValidISBN13Result #true
    end
    
    def quickSend
      step = startSteps().first
      driver = SOAP::WSDLDriverFactory.new('http://localhost:3000/soap/wsdl').create_rpc_driver(nil, "MessagePort")
      message = driver.DeliverMessageAfterInitTransaction({:username=>"maarten",:password=>"asdfasdf"},step,"Titel van quicksend Message","Mijn body") #OK
      puts "Bericht verstuurd met bericht id #{message.id}"
      puts message.inspect
    end

    #testSoap 
    #quickSend
    
    #step = startSteps.first
    #message = startTransaction(step)
    
    #puts showMessage(message.id).title
    #message.title = "updated title"
    #message.body = "updated title"
    #message = deliver(message)
    #puts message.inspect
    #updateMessage(message)
    # message = startTransaction(step)
    #     message.title = "delete me"
    #     updateMessage(message)
    #     puts "Alle berichten"
    #     index.each do |m| puts m.title end
    #     #deleteMessage(message) #Geen authorisatie
    #     puts "Alleen gelezen berichten"
     indexRead.each do |m| puts m.title end
    



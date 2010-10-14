    require 'soap/wsdlDriver'
    
    def testSoap
      #Even testen of SOAP werkt in de basis (uitvoer dient te beginnen met true) 
      wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
      driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
      response =  driver.IsValidISBN13(:sISBN => '9780393068474')
      puts response.isValidISBN13Result #true
    end
    
    ZORGAANBIEDER = 'http://localhost:3011/soap/wsdl'
    BUREAUJEUGDZORG = 'http://localhost:3010/soap/wsdl'

    def startTransaction(step, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "TransactionPort")
      transaction = driver.Initiate({:username=>"maarten",:password=>"asdfasdf"},step) #OK
      transaction
    end

    def deliver(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.Deliver({:username=>"maarten",:password=>"asdfasdf"},message)
    end

    def reply(message, step, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.Reply({:username=>"maarten",:password=>"asdfasdf"},message, step)
    end

    def updateMessage(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      message = driver.Update({:username=>"maarten",:password=>"asdfasdf"},message)
    end

    def index(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Index({:username=>"maarten",:password=>"asdfasdf"}) #OK
    end

    def indexRead(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.IndexRead({:username=>"maarten",:password=>"asdfasdf"}) #OK
    end
    
    def indexUnexpiredUnread(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.IndexUnexpiredUnread({:username=>"maarten",:password=>"asdfasdf"}) #OK      
    end

    def startSteps(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
      steps = driver.StartingStepsIndex({:username=>"maarten",:password=>"asdfasdf"}) #OK
      steps
    end

    def effectStepsIndex(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
      steps = driver.EffectStepsIndex({:username=>"maarten",:password=>"asdfasdf"}, message) #OK
      steps
    end
    
    def showMessage(id,endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Show({:username=>"maarten",:password=>"asdfasdf"},id) # "asdfasdf" #OK
    end

    def deleteMessage(message,endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Delete({:username=>"maarten",:password=>"asdfasdf"},message) # "asdfasdf" #OK
    end
    
    def deliverMessageAfterInitTransaction(titel, body, endpoint)
      step = startSteps(endpoint).first
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      message = driver.DeliverMessageAfterInitTransaction({:username=>"maarten",:password=>"asdfasdf"},step,titel,body) #OK
      puts "Bericht verstuurd met bericht id #{message.id}"
      puts message.inspect
    end

    testSoap 
    deliverMessageAfterInitTransaction("snelverzonden","<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>tadu tadu tadu</melding>",ZORGAANBIEDER)
    step = startSteps(ZORGAANBIEDER).first
    message = startTransaction(step,ZORGAANBIEDER)
    
    puts showMessage(message.id,ZORGAANBIEDER).title
    
    message.title = "Ik maak een handmatige melding melding"
    message.body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>updated title</melding>"
    
    updateMessage(message,ZORGAANBIEDER)
    
    deliver(message,ZORGAANBIEDER)
    
    index(BUREAUJEUGDZORG).each do |m| puts m.title end
    messageToReplyTo = indexUnexpiredUnread(BUREAUJEUGDZORG).first
    replysteps = effectStepsIndex(messageToReplyTo, BUREAUJEUGDZORG)
    replysteps.each do |s|
      puts s.title
    end
    replymessage = reply(messageToReplyTo,replysteps.first,BUREAUJEUGDZORG)
    replymessage.title = "Bedankt voor uw melding"
    replymessage.body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>updated title</melding>"
    replymessage = updateMessage(replymessage, BUREAUJEUGDZORG)
    deliver(replymessage, BUREAUJEUGDZORG)
    
    # deleteMessage(message) #Geen authorisatie
    # puts "Alleen gelezen berichten"
    # indexRead.each do |m| puts m.title end
    #      

    #indexUnexpiredUnread.each do |m| puts m.title end

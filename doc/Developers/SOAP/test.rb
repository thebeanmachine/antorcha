    require 'soap/wsdlDriver'
    
    def testSoap
      #Even testen of SOAP werkt in de basis (uitvoer dient te beginnen met true) 
      wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
      driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
      response =  driver.IsValidISBN13(:sISBN => '9780393068474')
      puts response.isValidISBN13Result #true
    end
    
    ZORGAANBIEDER = 'http://henk:qwerty@localhost:3000/soap/wsdl'
    BUREAUJEUGDZORG = 'http://henk:qwertyf@localhost:3000/soap/wsdl'
    # ZORGAANBIEDER = 'http://maarten:asdfasdf@localhost:3011/soap/wsdl'
    # BUREAUJEUGDZORG = 'http://maarten:asdfasdf@localhost:3011/soap/wsdl'
    #ZORGAANBIEDER = 'http://maarten:asdfasdf@zorgaanbieder.thebeanmachine.nl/soap/wsdl'
    #BUREAUJEUGDZORG = 'http://maarten:asdfasdf@zorgaanbieder.thebeanmachine.nl/soap/wsdl'

    
    def startTransaction(step, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "TransactionPort")
      transaction = driver.Initiate({:username=>"henk",:password=>"qwerty"},step) #OK
      transaction
    end

    def deliver(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.Deliver({:username=>"henk",:password=>"qwerty"},message)
    end

    def reply(message, step, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.Reply({:username=>"henk",:password=>"qwerty"},message, step)
    end

    def updateMessage(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      message = driver.Update({:username=>"henk",:password=>"qwerty"},message)
    end

    def index(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Index({:username=>"henk",:password=>"qwerty"}) #OK
    end

    def indexRead(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.IndexRead({:username=>"henk",:password=>"qwerty"}) #OK
    end
    
    def indexUnexpiredUnread(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.IndexUnexpiredUnread({:username=>"henk",:password=>"qwerty"}) #OK      
    end

    def startSteps(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
      steps = driver.StartingStepsIndex({:username=>"henk",:password=>"qwerty"}) #OK
      steps
    end

    def effectStepsIndex(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
      steps = driver.EffectStepsIndex({:username=>"henk",:password=>"qwerty"}, message) #OK
      steps
    end
    
    def showMessage(id,endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Show({:username=>"henk",:password=>"qwerty"},id) # "qwerty" #OK
    end

    def deleteMessage(message,endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Delete({:username=>"henk",:password=>"qwerty"},message) # "qwerty" #OK
    end
    
    def deliverMessageAfterInitTransaction(titel, body, endpoint)
      step = startSteps(endpoint).first
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      @message = driver.DeliverMessageAfterInitTransaction({:username=>"henk",:password=>"qwerty"},step,titel,body) #OK
      # puts "Bericht verstuurd met bericht id #{message.id}"
      # puts message.inspect
    end

    def stresstest number     
      @title = "Start 'deliverMessageAfterInitTransaction' SOAP-call stresstest."
      p @title

      number.times do |i|
        p "-" * @title.size
        p "soapcall #{i+1}: "
        deliverMessageAfterInitTransaction("snelverzonden","<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>tadu tadu tadu</melding>",ZORGAANBIEDER)
        p @message.body.empty? ? "NOT" : "OK"
      end
      
    end

    #testSoap 
    stresstest 100
    
    
    
    # step = startSteps(ZORGAANBIEDER).first
    # message = startTransaction(step,ZORGAANBIEDER)
    
    
    # 
    # puts showMessage(message.id,ZORGAANBIEDER).title
    # message.title = "Ik maak een handmatige melding melding"
    # message.body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>updated title</melding>"
    # updateMessage(message,ZORGAANBIEDER)
    # deliver(message,ZORGAANBIEDER)
    
    
    
    # 
    # index(BUREAUJEUGDZORG).each do |m| puts m.title end
    # messageToReplyTo = indexUnexpiredUnread(BUREAUJEUGDZORG).first
    # replysteps = effectStepsIndex(messageToReplyTo, BUREAUJEUGDZORG)
    # replysteps.each do |s|
    #    puts s.title
    # end
    # replymessage = reply(messageToReplyTo,replysteps.first,BUREAUJEUGDZORG)
    # replymessage.title = "Bedankt voor uw melding"
    # replymessage.body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>updated title</melding>"
    # replymessage = updateMessage(replymessage, BUREAUJEUGDZORG)
    # deliver(replymessage, BUREAUJEUGDZORG)
    # 
    # deleteMessage(message) #Geen authorisatie
    # puts "Alleen gelezen berichten"
    # indexRead.each do |m| puts m.title end
    #      

    #indexUnexpiredUnread.each do |m| puts m.title end

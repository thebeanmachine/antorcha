    require 'soap/wsdlDriver'
    
    def testSoap
      #Even testen of SOAP werkt in de basis (uitvoer dient te beginnen met true) 
      wsdl = 'http://webservices.daehosting.com/services/isbnservice.wso?WSDL'
      driver = SOAP::WSDLDriverFactory.new(wsdl).create_rpc_driver
      response =  driver.IsValidISBN13(:sISBN => '9780393068474')
      puts response.isValidISBN13Result #true
    end
    
    #ZORGAANBIEDER = 'http://maarten:asdfasdf@localhost:3011/soap/wsdl'
    BUREAUJEUGDZORG = 'http://maarten:asdfasdf@localhost:3011/soap/wsdl'
    #ZORGAANBIEDER = 'http://maarten:asdfasdf@zorgaanbieder.thebeanmachine.nl/soap/wsdl'
    #BUREAUJEUGDZORG = 'http://maarten:asdfasdf@zorgaanbieder.thebeanmachine.nl/soap/wsdl'
    ZORGAANBIEDER = 'http://vps765.directvps.nl/soap/wsdl'
    USERNAME = 'willems'
    PASSWORD = 'thorax01'

    
    def startTransaction(step, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "TransactionPort")
      transaction = driver.Initiate({:username=>USERNAME,:password=>PASSWORD},step) #OK
      transaction
    end

    def deliver(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.Deliver({:username=>USERNAME,:password=>PASSWORD},message)
    end

    def reply(message, step, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.Reply({:username=>USERNAME,:password=>PASSWORD},message, step)
    end

    def updateMessage(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      message = driver.Update({:username=>USERNAME,:password=>PASSWORD},message)
    end

    def index(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Index({:username=>USERNAME,:password=>PASSWORD}) #OK
    end

    def indexRead(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.IndexRead({:username=>USERNAME,:password=>PASSWORD}) #OK
    end
    
    def indexUnexpiredUnread(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      return driver.IndexUnexpiredUnread({:username=>USERNAME,:password=>PASSWORD}) #OK      
    end

    def startSteps(endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
      steps = driver.StartingStepsIndex({:username=>USERNAME,:password=>PASSWORD}) #OK
      steps
    end

    def effectStepsIndex(message, endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "StepPort")
      steps = driver.EffectStepsIndex({:username=>USERNAME,:password=>PASSWORD}, message) #OK
      steps
    end
    
    def showMessage(id,endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Show({:username=>USERNAME,:password=>PASSWORD},id) # PASSWORD #OK
    end

    def deleteMessage(message,endpoint)
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      driver.Delete({:username=>USERNAME,:password=>PASSWORD},message) # PASSWORD #OK
    end
    
    def deliverMessageAfterInitTransaction(titel, body, endpoint)
      step = selectProperSOAPTestingStep(endpoint)
      puts step.title
      driver = SOAP::WSDLDriverFactory.new(endpoint).create_rpc_driver(nil, "MessagePort")
      message = driver.DeliverMessageAfterInitTransaction({:username=>USERNAME,:password=>PASSWORD},step,titel,body) #OK
      puts "Bericht verstuurd met bericht id #{message.id}"
      puts message.inspect
    end
    
    def selectProperSOAPTestingStep(endpoint)
      steps = startSteps(endpoint)
      step = nil
      steps.each do |s| 
        step = s if s.title == 'XSDSend'
      end
      step
    end
     

    y selectProperSOAPTestingStep(ZORGAANBIEDER)

      puts ZORGAANBIEDER
      begin
        deliverMessageAfterInitTransaction("snelverzonden","<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>tadu tadu tadu</melding>",ZORGAANBIEDER)
        puts "ERROR: Dit bericht had niet mogen valideren (berichtstructuur is verkeerd)"
      rescue
        puts "Dit is goed, dit moet nl. fout gaan :)"
      end
      
      begin
        deliverMessageAfterInitTransaction("snelverzonden",'<?xml version="1.0" encoding="UTF-8"?>    <mhg xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="example.xsd">      <melding>        <p.informatieverzoek>true</p.informatieverzoek>      </melding>      <zaak>        <p.instelling>p.instelling</p.instelling>        <p.code_zaak>p.code_zaak</p.code_zaak>        <p.persoon_bekend>          <p.persoon_bekend>            <p.instelling>p.instelling</p.instelling>            <p.bekend>true</p.bekend>            <p.huiselijk_geweld>true</p.huiselijk_geweld>            <p.code_contactpersoon>p.code_contactpersoon</p.code_contactpersoon>            <p.code_persoon>p.code_persoon</p.code_persoon>          </p.persoon_bekend>        </p.persoon_bekend>        <p.omschrijving>p.omschrijving</p.omschrijving>        <p.datum_eerste_melding>2001-01-01</p.datum_eerste_melding>        <p.datum_start_hulp>2001-01-01</p.datum_start_hulp>      </zaak>      <contactpersoon>        <p.code_contactpersoon>p.code_contactpersoon</p.code_contactpersoon>        <p.instelling>p.instelling</p.instelling>        <p.persoonsnaam>          <p.achternaam>p.achternaam</p.achternaam>        </p.persoonsnaam>        <p.geslacht>p.geslacht</p.geslacht>      </contactpersoon>      <betrokkenen>        <p.persoonsnaam>          <p.voorletters>p.voorletters</p.voorletters>          <p.achternaam>p.achternaam</p.achternaam>        </p.persoonsnaam>        <p.voornamen>p.voornamen</p.voornamen>        <p.geslacht>p.geslacht</p.geslacht>        <p.adres>          <p.adres>            <p.straatnaam>p.straatnaam</p.straatnaam>            <p.huisnummer>0</p.huisnummer>            <p.postcode>p.postcode</p.postcode>            <p.plaatsnaam>p.plaatsnaam</p.plaatsnaam>          </p.adres>        </p.adres>        <p.code_persoon>p.code_persoon</p.code_persoon>        <p.laatste_persoon>true</p.laatste_persoon>      </betrokkenen>    </mhg>    ',ZORGAANBIEDER)
        puts "Dit is goed, dit is een goed bericht"
      rescue
        puts "ERROR: Dit bericht had moeten valideren"
        
      end
      
      begin
         deliverMessageAfterInitTransaction("snelverzonden",'<?xml version="1.0" encoding="UTF-8"?>    <mhg xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="example.xsd">      <melding>        <p.informatieverzoek>true</p.informatieverzoek>      </melding>      <zaak>        <p.instelling>p.instelling</p.instelling>        <p.code_zaak>p.code_zaak</p.code_zaak>        <p.persoon_bekend>          <p.persoon_bekend>            <p.instelling>p.instelling</p.instelling>            <p.bekend>true</p.bekend>            <p.huiselijk_geweld>true</p.huiselijk_geweld>            <p.code_contactpersoon>p.code_contactpersoon</p.code_contactpersoon>            <p.code_persoon>p.code_persoon</p.code_persoon>          </p.persoon_bekend>        </p.persoon_bekend>        <p.omschrijving>p.omschrijving</p.omschrijving>        <p.datum_eerste_melding>GEENDATUM</p.datum_eerste_melding>        <p.datum_start_hulp>2001-01-01</p.datum_start_hulp>      </zaak>      <contactpersoon>        <p.code_contactpersoon>p.code_contactpersoon</p.code_contactpersoon>        <p.instelling>p.instelling</p.instelling>        <p.persoonsnaam>          <p.achternaam>p.achternaam</p.achternaam>        </p.persoonsnaam>        <p.geslacht>p.geslacht</p.geslacht>      </contactpersoon>      <betrokkenen>        <p.persoonsnaam>          <p.voorletters>p.voorletters</p.voorletters>          <p.achternaam>p.achternaam</p.achternaam>        </p.persoonsnaam>        <p.voornamen>p.voornamen</p.voornamen>        <p.geslacht>p.geslacht</p.geslacht>        <p.adres>          <p.adres>            <p.straatnaam>p.straatnaam</p.straatnaam>            <p.huisnummer>0</p.huisnummer>            <p.postcode>p.postcode</p.postcode>            <p.plaatsnaam>p.plaatsnaam</p.plaatsnaam>          </p.adres>        </p.adres>        <p.code_persoon>p.code_persoon</p.code_persoon>        <p.laatste_persoon>true</p.laatste_persoon>      </betrokkenen>    </mhg>    ',ZORGAANBIEDER)
         puts "ERROR: Dit bericht had niet mogen valideren (datum is geen datum maar een string)"
       rescue
         puts "Dit is goed hij moet nl. falen op datum"
         
       end
      
    # deliverMessageAfterInitTransaction("snelverzonden","<?xml version=\"1.0\" encoding=\"UTF-8\"?><melding>tadu tadu tadu</melding>",ZORGAANBIEDER)
    # step = startSteps(ZORGAANBIEDER).first
    # message = startTransaction(step,ZORGAANBIEDER)
    # # 
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

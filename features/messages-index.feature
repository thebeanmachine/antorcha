Feature: Messages index
  In order to see what I sent and received
  As a user
  I want to have an overview of all messages

  
  Scenario: I can see what I have already read
    Given I have a message "My message"
    When I am on the messages page
    And I follow "My message"
    And I follow "Berichten"
    Then I should see "My message" within ".shown"

    
  Scenario: I can see the incoming messages
    Given I have a incoming message "Incoming message"
    And I have a outgoing message "Outgoing message"
    When I am on the messages page
    And I follow "Inkomende"
    Then I should see "Incoming message"
    And I should not see "Outgoing message"
  
  
  Scenario: I can see the outgoing messages
    Given I have a incoming message "Incoming message"
    And I have a outgoing message "Outgoing message"
    When I am on the messages page
    And I follow "Uitgaande"
    Then I should not see "Incoming message"
    And I should see "Outgoing message"
  

  

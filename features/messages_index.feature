Feature: Messages index
  In order to see what I sent and received
  As a user
  I want to have an overview of all messages
  
  Scenario: I can see what I have already read
    Given I have a message "My message"
    When I am on the messages page
    And I follow "My message"
    And I follow "Back"
    Then I should see "My message" within ".shown"
    
  
  
  

  

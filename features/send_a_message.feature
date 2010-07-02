Feature: Create a message
  In order to start a transaction 
  As a user
  I want to sent a message
  
  Scenario: Sending a message
    Given I have a starting step "Hello world"
    And I have a message "Hello world" for step "Hello world"
    When I am on the "Hello world" message page
    And I press "Act as sender"
    And I press "Verstuur Bericht"
    Then I should see "Message is being sent"
    And I should see "Message was sent at"
    And I should see "and not received"
    And I should not see submit button "Verstuur Bericht"
  
  
  

  

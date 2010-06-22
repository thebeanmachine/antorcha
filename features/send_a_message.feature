Feature: Create a message
  In order to start a task 
  As a user
  I want to sent a message
  
  Scenario: Sending a message
    Given I have a starting instruction "Hello world"
    And I have a message "Hello world" for instruction "Hello world"
    When I am on the "Hello world" message page
		And show me the page
    And I press "Send"
    Then I should see "Message is being sent"
    And I should see "Message is sent at"
    And I should see "and not received"
    And I should not see submit button "Send"
  
  
  

  

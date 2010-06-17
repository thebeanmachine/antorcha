Feature: Send a message
  In order to communicate an inquiry
  As a user
  I want to sent a message
  
  Scenario: Sending a message
    Given I have a starting step "Hello world"
    And I have a message "Hallo wereld" for step "Hello world"
    When I am on the "Hallo wereld" message page
    And I press "Verstuur"
    Then I should see "Bericht wordt verzonden"

  
  
  

  

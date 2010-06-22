Feature: Send a message
  In order to communicate an inquiry
  As a user
  I want to sent a message
  
  Scenario: Sending a message
    Given I have a starting instruction "Hello world"
    And I have a message "Hallo wereld" for instruction "Hello world"
    When I am on the "Hallo wereld" message page
    And I press "Verstuur"
    Then I should see "Bericht wordt verzonden"
    And I should see "Bericht is verstuurd op"
    And I should see "en nog niet aangekomen"
    And I should not see submit button "Verstuur"
  
  
  

  

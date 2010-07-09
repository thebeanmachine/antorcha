Feature: Create a message
  In order to start a transaction 
  As a user
  I want to sent a message
  
  Scenario: Sending a message
    Given I have a starting step "Hello world"
    And I have a message "Hello world" for step "Hello world"
    When I am on the "Hello world" message page
    And I press "Act as communicator"
    And I press "Verstuur Bericht"
    Then I should see "Bericht is succesvol bij de uitgaande post terechtgekomen"
    And I should see "Bericht is in postvak uit geplaatst om"
    And I should see "en word momenteel verzonden"
    And I should not see submit button "Verstuur Bericht"
  

Feature: Send a message
  In order to start a task 
  As a user
  I want to sent a message
  
  Scenario: Sending a message
    Given I have a starting instruction "Hello world"
    And I have a message "Hello world" for instruction "Hello world"
    When I am on the "Hello world" message page
    And I press "Create Message"
    Then I should see "Message is send"
    And I should see "Bericht is verstuurd op"
    And I should see "en nog niet aangekomen"
    And I should not see submit button "Verstuur"
  
  
  

  

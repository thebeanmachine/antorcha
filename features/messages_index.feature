Feature: Messages index
  In order to see what I sent and received
  As a user
  I want to have an overview of all messages
  
  Scenario: I can see what I have already read
    Given I have a message "Mijn bericht"
    When I am on the messages page
    And I follow "Mijn bericht"
    And I follow "Terug naar alle berichten"
    Then I should see "Mijn bericht" within ".shown"
    
  
  
  

  

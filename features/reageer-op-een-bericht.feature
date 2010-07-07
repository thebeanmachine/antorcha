Feature: Reageer op een bericht
  In order to communicate with a communicator
  As a user
  I want to be able to reply on a message
  
  Scenario: Reply to a message is reachable from the show message page
    Given the "Bakkerij" example
    And I am a communicator
    And I have an incoming message "Aap noot mies" for step "Deeg kneden"
    When I am on the "Aap noot mies" message page
    Then I should see "Reageer op Bericht"
    And I should not see "Verstuur Bericht"
    And I should not see "Bewerk Bericht"


  Scenario: Reply to a message
    Given the "Bakkerij" example
    And I am a communicator
    And I have an incoming message "Aap noot mies" for step "Deeg kneden"

    When I am on the "Aap noot mies" message page
    And I follow "Reageer op Bericht"
    Then I should see "Reageer op Bericht"


  Scenario: Reply to a message and select a reply step
    Given the "Bakkerij" example
    And I am a communicator
    And I have an incoming message "Met mijn handen" for step "Deeg kneden"

    When I am on the "Met mijn handen" message page
    And I follow "Reageer op Bericht"
    And I choose "In bakvorm stoppen"
  
    And I press "Maak Bericht"
    
    Then I should see "Bericht was succesvol aangemaakt"

  

Feature: Start a new Definition using a start step
  In order to start a new Definition
  As a User
  I want choose a starting step and create a message.


  Scenario: I can choose a starting step on the messages index page.
    Given I have a starting step "Defrost doh"
    When I am on the messages page
    Then I should see "Nieuwe transactie"


  Scenario: I can initiate a transaction using a starting step (shortcut)
    Given I have a starting step "Deeg kneden"
    And I am on the messages page
    When I follow "Nieuwe transactie"
    And I choose "Deeg kneden"
    And I press "Maak Transactie"
    
    Then I should see "Transactie succesvol aangemaakt"

  Scenario: I can create a message of a starting step (the long route)
    Given I have a definition "Taart bakken"
    And I have a starting step "Kneed deeg" in "Taart bakken"
    And I am on the new transaction page
    And I press "Act as maintainer"

    When I fill in "Titel" with "Chocolade taart bakken"
    And I choose "Taart bakken"
    And I press "Maak Transactie"

    Then I should see "Transaction was successfully created"
    And I should see "Chocolade taart bakken"
  
    When I follow "Nieuwe transactie"
    And I choose "Kneed deeg"
    #And I fill in "Titel" with "Bladerdeeg kneden"
    And I press "Maak Transactie"
    
    Then I should see "Transactie succesvol aangemaakt"
    
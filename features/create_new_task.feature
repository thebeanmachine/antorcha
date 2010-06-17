Feature: Create new task
  In order to define communication between antorchas
  As a advisor
  I want to create new tasks and steps under it.

  Scenario: Create a new task
    Given I am on the new task page
    When I fill in "Titel" with "Mijn taak"
    And I press "Maak Transactiedefinitie"
    Then I should see "Transactiedefinitie succesvol aangemaakt"

  Scenario: Create a new step under a task
    Given I have a task "Mijn taak"
    When I am on the "Mijn taak" task page
    And I follow "Nieuwe stap"
    Then I should see "Nieuwe stap"
  
  Scenario: Create a new step under a task
    Given I have a task "Mijn taak"
    When I am on the "Mijn taak" task page
    And I follow "Nieuwe stap"
    And I fill in "Titel" with "Mijn stap"
    And I press "Maak Stap"
    Then I should see "Stap succesvol aangemaakt"
    And I should see "binnen transactie Mijn taak"

  
  

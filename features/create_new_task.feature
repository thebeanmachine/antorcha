Feature: Create new task
  In order to define communication between antorchas
  As a advisor
  I want to create new tasks

  Scenario: Create a new task
    Given I am on the new task page
    When I fill in "Titel" with "Mijn taak"
    And I press "Maak Transactiedefinitie"
    Then I should see "Transactiedefinitie succesvol aangemaakt"

  
  
  
  

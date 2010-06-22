Feature: Start a new Procedure using a start instruction
  In order to start a new Procedure
  As a User
  I want choose a starting instruction and create a message.
  
  Scenario: I can choose a starting instruction on the messages index page.
    Given I have a starting instruction "Hello world"
    When I am on the messages page
    Then I should see "Start een nieuwe transactie"
    And I should see "Start Hello world"
  
  Scenario: I can follow a starting instruction
    Given I have a starting instruction "Hello world"
    When I am on the messages page
    And I follow "Start Hello world"
    Then I should see "Start een nieuwe 'Hello world'"

  Scenario: I can create a message of a starting instruction
    Given I have a starting instruction "Hello world"
    And I am on the new instruction message page of "Hello world"

    When I fill in "Titel" with "Hallo wereld"
    And I press "Maak Bericht"
    Then I should see "Bericht was succesvol aangemaakt"
    And I should see "Hello world"

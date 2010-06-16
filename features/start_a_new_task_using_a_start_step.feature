Feature: Start a new Task using a start step
  In order to start a new Task
  As a User
  I want choose a starting step and create a message.
  
  Scenario: I can choose a starting step on the messages index page.
    Given I have a starting step "Hello world"
    When I am on the messages page
    Then I should see "Start een nieuwe transactie"
    And I should see "Start Hello world"
  
  Scenario: I can follow a starting step
    Given I have a starting step "Hello world"
    When I am on the messages page
    And I follow "Start Hello world"
    Then I should see "Start een nieuwe 'Hello world'"

  Scenario: I can create a message of a starting step
    Given I have a starting step "Hello world"
    And I am on the new step message page of "Hello world"

    When I fill in "Title" with "Hallo wereld"
    And I press "Create message"
    Then I should see "Bericht was succesvol aangemaakt"
    And I should see "Hello world"

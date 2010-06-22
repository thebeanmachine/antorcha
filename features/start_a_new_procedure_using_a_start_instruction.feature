Feature: Start a new Procedure using a start instruction
  In order to start a new Procedure
  As a User
  I want choose a starting instruction and create a message.
  
  Scenario: I can choose a starting instruction on the messages index page.
    Given I have a starting instruction "Defrost doh"
    When I am on the messages page
    Then I should see "Start a new instruction"
    And I should see "Start: Defrost doh"

  
  Scenario: I can follow a starting instruction
    Given I have a starting instruction "Defrost doh"
    When I am on the messages page
    And I follow "Start: Defrost doh"
    Then I should see "Start een nieuwe 'Defrost doh'"


  Scenario: I can create a message of a starting instruction
    Given I have a starting instruction "Defrost doh"
    And I am on the new instruction message page of "Defrost doh"
    When I fill in "Title" with "Defrosting doh"
    And I press "Create Message"
    Then I should see "Message was successfully created"
    And I should see "Defrosting doh"

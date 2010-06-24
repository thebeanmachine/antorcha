Feature: Start a new Definition using a start step
  In order to start a new Definition
  As a User
  I want choose a starting step and create a message.
  
  Scenario: I can choose a starting step on the messages index page.
    Given I have a starting step "Defrost doh"
    When I am on the messages page
    Then I should see "Start a new step"
    And I should see "Start: Defrost doh"

  
  Scenario: I can follow a starting step
    Given I have a starting step "Defrost doh"
    When I am on the messages page
    And I follow "Start: Defrost doh"
    Then I should see "Start een nieuwe 'Defrost doh'"

  @wip
  Scenario: I can create a message of a starting step
    Given I have a starting step "Defrost doh"
    And I am on the new step message page of "Defrost doh"
    When I fill in "Title" with "Defrosting doh"
    And I press "Create Message"
    Then I should see "Message was successfully created"
    And I should see "Defrosting doh"

Feature: Cancel task
  In order stop colleagues from doing unnecessary work
  As a user
  I want to be able to cancel a task
  
  Scenario: Create a task
    Given I have a procedure "Bake bread"
    And I am on the new task page
    When I fill in "Title" with "Bake bread for George"
    And I select "Bake bread" from "Procedure"
    And I press "Create Task"
    Then I should see "Task was successfully created"

  Scenario: Cancel a task
    Given I have a procedure "Bake bread"
    And I am on the new task page
    When I fill in "Title" with "Bake bread for George"
    And I select "Bake bread" from "Procedure"
    And I press "Create Task"
    And I press "Cancel Task"
    Then I should see "Task was successfully cancelled"
    And I should not see "Cancel Task"
  
  

  

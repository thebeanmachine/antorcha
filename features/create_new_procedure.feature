Feature: Create new Procedure
  In order to define communication between antorchas
  As a advisor
  I want to create new Procedures and Instructions under it.

  Scenario: Create a Procedure
    Given I am on the new procedure page
    When I fill in "Title" with "My defined Procedure"
    And I press "Create"
    Then I should see "Procedure created successfully"
  

  # Scenario: Create an Instruction within a Procedure
  #   Given I have a procedure "My defined Procedure"
  #   When I am on the "My defined Procedure" procedure page
  #   And I follow "New Instruction"
  #   Then I should see "New Instruction"
  

  Scenario: Create an Instruction under a Procedure
    Given I have a procedure "My defined Procedure"
    When I am on the "My defined Procedure" procedure page
    And I follow "New Instruction"
    And I fill in "Title" with "My defined Instruction"
    And I press "Create Instruction"
    Then I should see "Instruction created successfully"
  


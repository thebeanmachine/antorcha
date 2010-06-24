Feature: Cancel transaction
  In order stop colleagues from doing unnecessary work
  As a user
  I want to be able to cancel a transaction
  
  Scenario: Create a transaction
    Given I have a definition "Bake bread"
    And I am on the new transaction page
    When I fill in "Title" with "Bake bread for George"
    And I choose "Bake bread"
    And I press "Create Transaction"
    Then I should see "Transaction was successfully created"

  Scenario: Cancel a transaction
    Given I have a definition "Bake bread"
    And I am on the new transaction page
    When I fill in "Title" with "Bake bread for George"
    And I choose "Bake bread"
    And I press "Create Transaction"
    And I press "Cancel Transaction"
    Then I should see "Transaction was successfully cancelled"
    And I should not see "Cancel Transaction"
  
  

  

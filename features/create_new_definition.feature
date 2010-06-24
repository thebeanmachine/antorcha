Feature: Create new Definition
  In order to define communication between antorchas
  As a advisor
  I want to create new Definitions and Steps under it.

  Scenario: Create a Definition
    Given I am on the new definition page
    When I fill in "Title" with "My defined Definition"
    And I press "Create"
    Then I should see "Definition created successfully"
  

  Scenario: Create an Step within a Definition
    Given I have a definition "My defined Definition"
    When I am on the "My defined Definition" definition page
    And I follow "Steps" within ".page"
    And I follow "New Step"
    Then I should see "New Step"
  

  Scenario: Create an Step under a Definition
    Given I have a definition "My defined Definition"
    When I am on the "My defined Definition" definition page
    And I follow "Steps" within ".page"
    And I follow "New Step"
    And I fill in "Title" with "My defined Step"
    And I press "Create Step"
    Then I should see "Step created successfully"
  


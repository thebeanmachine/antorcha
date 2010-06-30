Feature: Begeleid worden bij reageren
  In order to provide the user with guidance
  As a advisor
  I want to model the communication paths
  

  Scenario: Mark "Bak brood" as cause of effect "Verkoop brood" in a "Bakkerij"
    Given I have a definition "Bakkerij"
    And I have a step "Bak brood" in "Bakkerij"
    And I have a step "Verkoop brood" in "Bakkerij"
    And I am on the "Bakkerij" definition page
    And I follow "Stappen"
    And I press "Act as maintainer"
    When I follow "Verkoop brood"
    And I follow "Bewerk Stap"
    And I check "Bak brood"
    And I press "Bewaar veranderingen"
    
    Then I should see "Stap heeft als oorzaak Bak brood"
  
  

  

Feature: Cancel transaction
  In order stop colleagues from doing unnecessary work
  As a user
  I want to be able to cancel a transaction
  
  Scenario: Een gebruiker heeft een bericht gestuurd en wil deze annuleren
		Given the VIS2 transaction definition is available
		And I am logged in as a "communicator"
		And I am on the messages page
		When I follow "Nieuwe Transactie"
		Then I should see "Melding aan VIS2"
		When I follow "Reageer"
		Then I should see "Reactie op melding VIS2" within "label"
		And I should not see "Melding aan VIS2" within "label"
		And I should see "Informatieverzoek (gegevens actueel houden)" within "label"
		And I should not see "Reactie op informatieverzoek" within "label"

  @selenium
  Scenario: Cancel a transaction
    Given I have a definition "Bake bread"
    And I am on the new transaction page
    And I press "Act as communicator"
    And I fill in "Titel" with "Bake bread for George"
    And I choose "Bake bread"
    And I press "Maak Transactie"
    And I confirm a js popup on the next step
    And I press "Annuleer Transactie"

    When the system processes jobs
    And I am on the "Bake bread for George" transaction page
  
    Then I should see "Deze transactie is geannuleerd op"
    
  

  

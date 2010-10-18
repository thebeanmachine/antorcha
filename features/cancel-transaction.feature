Feature: Cancel transaction
  In order stop colleagues from doing unnecessary work
  As a user
  I want to be able to cancel a transaction
  
  Scenario: Een gebruiker heeft een bericht gestuurd en wil deze annuleren
		Given the VIS2 transaction definition is available
		And I have an outgoing message "Melding aan VIS2" for step "Melding aan VIS2"
		And I am logged in as a "communicator"
		And I am on the messages page
		And show me the page
		When I follow "Melding aan VIS2"
		Then I should see "Melding aan VIS2"
		And show me the page
		When I press "Annuleer Transactie"
		Then I should see "De transactie wordt geannuleerd"

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
    
  

  

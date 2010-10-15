Feature: Begeleid worden bij reageren
  Ik wil enkel relevante stappen zien bij het antwoorden op een 
  bericht voor een transactie, dus niet met stappen kunnen
  antwoorden die niet volgens de definitie zijn toegestaan

  Scenario: Ik zit in de tweede stap van transactie en wil reageren, ik zie dan niet alle stappen in de transactie
		Given the VIS2 transaction definition is available
		And I have an incoming message "Melding aan VIS2" for step "Melding aan VIS2"
		And I am logged in as a "communicator"
		And I am on the messages page
		Then I should see "Berichten"
		When I follow "Melding aan VIS2"
		Then I should see "Reageer op Bericht"
		When I follow "Reageer op Bericht"
		Then I should see "Reactie op melding VIS2" within "label"
		And I should not see "Melding aan VIS2" within "label"
		And I should see "Informatieverzoek (gegevens actueel houden)" within "label"
		And I should not see "Reactie op informatieverzoek" within "label"
  
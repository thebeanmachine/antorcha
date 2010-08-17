Feature: Begeleid worden bij reageren
  Ik wil enkel relevante stappen zien bij het antwoorden op een 
  bericht voor een transactie, dus niet met stappen kunnen
  antwoorden die niet volgens de definitie zijn toegestaan

  Scenario: Ik zit in de tweede stap van transactie en wil reageren, ik zie dan niet alle stappen in de transactie
		Given the VIS2 transaction definition is available
		And having received a message titled "Stap te antwoorden" based on the first startstep in the VIS2 transaction definition
		And I am on the messages page
		When I click "Stap te antwoorden"
  
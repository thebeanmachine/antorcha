Feature: Adviser filters messages by definitions
	As a adviser
	I want to filter messages by definitions
	So that I can confirm
	
	#pending #geen valide testmethode, er zouden twee testransacties gemaakt moeten worden, met verschillende namen
	Scenario: List messages by a definition
		Given I have a transaction "Afmelden bij BJZ"
		And I am an advisor
		When I am on the messages page
		And I follow "Afmelden bij BJZ"
		#Then I should see "een overzicht zien van alle berichten per transactie type binnen mijn Antorcha"

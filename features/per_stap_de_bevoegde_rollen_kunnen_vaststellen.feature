Feature: Adviser add roles to step
	As a adviser
	I want to add roles to a step
	So that messages are authorised
	
	Scenario: Add role to step
	  Given the "Bakkerij" example
		And definition "Bakkerij" has roles titled Consulent, Verpleger
		And I am an advisor
		And I am on the "Bakkerij" definition page
		When I follow "Stappen" within "#page"

		And I follow "Nieuwe Stap"
		And I fill in "Titel" with "Uber Coole Stap"
		And I check step permission "Consulent"
		And I press "Maak Stap"

#		When I create a step Melding with role Consulent
#		Then Melding should be in the Consulent role
	
	# Scenario: check roles on a new step page
	# 	Given	I have a new untitled step
	# 	And a role titled "Receptionist"
	# 	And a role titled "Verpleger"
	# 	And an unchecked role on "Receptionist"
	# 	And an unchecked role on "Verpleger"
	# 	When I am on this new step page
	# 	And I fill in "Titel" with "Melding making bij BJZ"
	# 	And I check role "Receptionist"
	# 	And I check role "Verpleger"
	# 	And I press "Create Step"
	# 	Then I should see "Step is successfully created"
	# 	
	# Scenario: check roles on a edit step page
	# 	Given	I have an existing step titled "Melding making bij BJZ"
	# 	And a checked role on "Receptionist"
	# 	And a checked role on "Verpleger"
	# 	When I am on this existing step page
	# 	When I uncheck role "Receptionist"
	# 	And I press "Update Step"
	# 	Then I should see "Step is successfully updated"
		
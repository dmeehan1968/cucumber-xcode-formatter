Feature: Custom Formatter compatible with Xcode 6

	I would like to be able to run Cucumber within Xcode and see
	failing steps in the Xcode Issue Navigator
	As a developer using Xcode and C++
	So that I can have less friction in my BDD work

Background:
	Given a file named "features/f.feature" with:
	"""
	Feature: My Feature
	  Scenario: Passing
	    Given this step sometimes passes
	    And this step always passes
	"""
	
Scenario: Passing

	Passing steps are always silent
	
	Given a file named "features/step_definitions/passing.rb" with:
		"""
		Given /passes/ {}
		"""
	When I run `cucumber --strict`
	Then it should pass with exactly:
		"""
		"""
	
Scenario: Undefind step

	Undefined steps are treated as warnings
	
	When I run `cucumber --strict`
	Then it should fail with exactly:
		"""
		features/f.feature:3: warning: Given this step sometimes passes (Undefined)
		features/f.feature:4: warning: And this step always passes (Undefined)
		"""
	
Scenario: Failing steps

	Failing steps are treated as errors.  Steps following an 
	error are skipped
	
	Given a file named "features/step_definitions/failing.rb" with:
		"""
		Given /sometimes/ { raise 'doh' }
		"""
	When I run `cucumber --strict`
	Then it should fail with exactly:
		"""
		features/f.feature:3: error: Given this step sometimes passes # failing.rb:1
		features/f.feature:4: warning: And this step always passes (Skipped)
		"""
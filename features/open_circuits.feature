Feature: Open Circuits
  As a developer
  I do not want to use failing services
  So that I can minimize and mitigate failure in my application

  Scenario: Open Circuit Does Not Run
    Given a circuit that is currently open
    When I attempt to run a task through the circuit
    Then I should see that the task has not been run

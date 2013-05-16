Feature: Closed Circuits
  As a developer
  I want to use services without worrying about whether they are running
  So that I can minimize and mitigate failure in my application

  Scenario: Closed Circuit Runs Successfully
    Given a circuit that is currently closed
    When I attempt to run a task through through the circuit
    Then I should see that the task has been run
    And I should see that the circuit remains closed

  Scenario: Closed Circuit Fails With Callback
    Given a circuit that is currently closed
    When I provide a failure callback
    And I run a failing task through the circuit
    Then I should see that the task has been run
    And I should see that the failure callback has been called with the failure exception

  Scenario: Closed Circuit Fails Once and Tries Again
    Given a circuit that is configured to open after 2 failures
    And that is currently closed
    When I run a failing task through the circuit
    Then I should see that the task has been run
    And I should see that the circuit remains closed

  Scenario: Closed Circuit Fails and Opens
    Given a circuit that is configured to open after 1 failure
    And that is currently closed
    When I run a failing task through the circuit
    Then I should see that the task has been run
    And I should see that the circuit has opened

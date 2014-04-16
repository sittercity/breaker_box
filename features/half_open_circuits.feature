Feature: Half Open Circuits
  As a developer
  I want to retry on services that have failed in the past
  In order to allow my application to recover while mitigating the risk of failure

  Scenario Outline: Half-Open Circuit Runs Successfully
    Given I have a <persistence> persistence factory
    And a circuit that is currently half-open
    When I attempt to run a task through through the circuit
    Then I should see that the task has been run
    And I should see that the circuit has closed

    Examples:
      | persistence |
      | memory      |
      | redis       |

  Scenario Outline: Half-Open Circuit Fails Once
    Given I have a <persistence> persistence factory
    And a circuit that is currently half-open
    When I run a failing task through the circuit
    Then I should see that the task has been run
    And I should see that the circuit has opened

    Examples:
      | persistence |
      | memory      |
      | redis       |

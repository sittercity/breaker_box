require 'breaker_box'

class TestTask
  attr_accessor :has_run

  def call
    @has_run = true
  end
end

class FailureCallback
  attr_accessor :error

  def call(error)
    @error = error
  end
end

class FailingTask < TestTask
  def call
    @has_run = true
    raise CircuitBreakerException
  end

  class CircuitBreakerException < Exception; end
end

Given(/^a circuit that is currently closed$/) do
  @circuit = BreakerBox.circuit_for(:test)
end

When(/^I attempt to run a task through through the circuit$/) do
  @task = TestTask.new
  @circuit.run @task
end

Then(/^I should see that the task has been run$/) do
  @task.has_run.should be_true
end

Then(/^I should see that the circuit remains closed$/) do
  new_circuit = BreakerBox.circuit_for(:test)
  new_circuit.closed?.should be_true
end

When(/^I provide a failure callback$/) do
  @failure_callback = FailureCallback.new
  @circuit.failure_callback = @failure_callback
end

When(/^I run a failing task through the circuit$/) do
  @task = FailingTask.new
  @circuit.run @task
end

Then(/^I should see that the failure callback has been called with the failure exception$/) do
  @circuit.failure_callback.error.should be_a(FailingTask::CircuitBreakerException)
end

Given(/^that is configured to open after (\d+) failures$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

Given(/^that is configured to open after (\d+) failure$/) do |arg1|
    pending # express the regexp above with the code you wish you had
end

Then(/^I should see that the circuit has opened$/) do
    pending # express the regexp above with the code you wish you had
end

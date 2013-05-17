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
  @circuit.failure_callback = @failure_callback || lambda { |e| }
  @circuit.run @task
end

Then(/^I should see that the failure callback has been called with the failure exception$/) do
  @failure_callback.error.should be_a(FailingTask::CircuitBreakerException)
end

Given(/^a circuit that is configured to open after (\d+) failures?$/) do |failure_count|
  BreakerBox.configure(:test, :failure_threshold_count => failure_count.to_i)
end

Given(/^that is currently closed$/) do
  @circuit = BreakerBox.circuit_for(:test)
end

Then(/^I should see that the circuit has opened$/) do
  new_circuit = BreakerBox.circuit_for(:test)
  new_circuit.closed?.should be_false
end

Given(/^a circuit that is currently open$/) do
  @circuit = BreakerBox.circuit_for(:test)
  fail(@circuit)
end

When(/^I attempt to run a task through the circuit$/) do
  @task = TestTask.new
  @circuit.run @task
end

Then(/^I should see that the task has not been run$/) do
  @task.has_run.should be_falsey
end

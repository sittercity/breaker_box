Given(/^a circuit that is currently half\-open$/) do
  @circuit = BreakerBox.circuit_for(:test)
  @circuit.options = {:open_after => 1, :timeout => 2}
  Timecop.freeze Time.now.utc+5
end

Then(/^I should see that the circuit has closed$/) do
  @circuit.closed?.should be_true
end

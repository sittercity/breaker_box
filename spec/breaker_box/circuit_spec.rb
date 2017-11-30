require 'spec_helper'
require 'breaker_box/circuit'
require 'breaker_box/storage/memory'

describe BreakerBox::Circuit do
  let(:task) { TestTask.new }
  let(:failing_task) { FailingTask.new }
  let(:failure_callback) { double(:callback, :call => true) }
  let(:threshold) { 2 }

  let(:persistence) { BreakerBox::Storage::Memory.new }

  subject {
    breaker = described_class.new(persistence)
    breaker.options = {
      :failure_threshold_count => threshold,
      :failure_threshold_time => 120,
      :retry_after => 2,
      :on_failure => failure_callback
    }
    breaker
  }

  it 'gets constructed with state closed' do
    subject.closed?.should be true
  end

  it 'gets constructed with state open' do
    persistence_with_failures = double("BreakerBox::Storage::Memory")
    persistence_with_failures.stub(:all_since).and_return([1, 1, 1, 1,])
    subject = described_class.new(persistence_with_failures)
    subject.closed?.should be false
  end

  it 'runs the task and stays closed when the task passes' do
    subject.run task
    task.has_run.should be true
    subject.closed?.should be true
  end

  it 'stays closed when the task passes a number of times under the threshold' do
    subject.run failing_task
    subject.closed?.should be true
  end

  it 'opens when the fail threshold is met' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    subject.closed?.should be false
  end

  it 'runs a failure callback if specified when the task fails' do
    failure_callback.should_receive(:call).once.with(kind_of(FailingTask::CircuitBreakerException))
    subject.run failing_task
  end

  it 're-raises the exception if a failure callback is not provided' do
    subject.failure_callback = nil
    lambda { subject.run failing_task }.should raise_error(FailingTask::CircuitBreakerException)
  end

  it 'does not run the task when open' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    subject.run task
    task.has_run.should_not be true
  end

  it 'runs the task when half open' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    Timecop.freeze Time.now.utc + 5

    subject.run task
    task.has_run.should be true
  end

  it 'does not reopen immediately after re-closing' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    Timecop.freeze Time.now.utc + 5

    subject.run task
    task.has_run.should be true
    subject.closed?.should be true

    subject.run failing_task
    subject.closed?.should be true
  end

  it 'will tolerate fewer failures than the threshold within the time interval' do
    subject.run failing_task

    Timecop.freeze Time.now.utc + 121

    subject.run failing_task
    subject.closed?.should be true
  end
end

require 'spec_helper'
require 'breaker_box/circuit'

describe BreakerBox::Circuit do
  let(:task) { TestTask.new }
  let(:failing_task) { FailingTask.new }
  let(:failure_callback) { double(:callback, :call => true) }
  let(:threshold) { 2 }

  subject {
    breaker = described_class.new
    breaker.options = {
      :open_after => threshold,
      :timeout => 2,
      :on_failure => failure_callback
    }
    breaker
  }

  it 'runs the task and stays closed when the task passes' do
    subject.run task
    task.has_run.should be_true
    subject.closed?.should be_true
  end

  it 'stays closed when the task passes a number of times under the threshold' do
    subject.run failing_task
    subject.closed?.should be_true
  end

  it 'opens when the fail threshhold is met' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    subject.closed?.should be_false
  end

  it 'runs a failure callback if specified when the task fails' do
    failure_callback.should_receive(:call).once.with(kind_of(FailingTask::CircuitBreakerException))
    subject.run failing_task
  end

  it 'does not run the task when open' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    subject.run task
    task.has_run.should_not be_true
  end

  it 'runs the task when half open' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    Timecop.freeze Time.now.utc + 5

    subject.run task
    task.has_run.should be_true
  end

  it 'does not reopen immediately after reclosing' do
    (1..threshold).each do |n|
      subject.run failing_task
    end

    Timecop.freeze Time.now.utc + 5

    subject.run task
    task.has_run.should be_true
    subject.closed?.should be_true

    subject.run failing_task
    subject.closed?.should be_true
  end

  it 'will tolerate fewer failures thant the threshold within the time interval' do
    subject.run failing_task

    Timecop.freeze Time.now.utc + 121

    subject.run failing_task
    subject.closed?.should be_true
  end
end

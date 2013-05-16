require 'breaker_box'
require 'timecop'

Before do
  BreakerBox.reset!
end

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

class MyWorld
  def fail(breaker)
    while breaker.closed? do
      breaker.run FailingTask.new
    end
  end
end

World do
  MyWorld.new
end

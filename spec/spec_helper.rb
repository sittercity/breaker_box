require 'timecop'
require 'breaker_box/memory_storage'

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
    raise error unless error.is_a? FailingTask::CircuitBreakerException
  end
end

class FailingTask < TestTask
  def call
    @has_run = true
    raise CircuitBreakerException
  end

  class CircuitBreakerException < Exception; end
end

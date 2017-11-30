require 'timecop'
require 'simplecov'
require 'simplecov-rcov'

unless ENV["REDIS_URI"]
  puts "\n*** REDIS_URI can be set to control the testing connection ***\n\n"
end

SimpleCov.start do
  coverage_dir 'reports/coverage'
  formatter SimpleCov::Formatter::RcovFormatter
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

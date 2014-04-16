require 'timecop'
require 'breaker_box'
require 'breaker_box/persistence_factories/memory'
require 'breaker_box/persistence_factories/redis'

class MyWorld
  def fail(breaker)
    while breaker.closed? do
      breaker.failure_callback = lambda {|arg| }
      breaker.run FailingTask.new
    end
  end
end

World do
  MyWorld.new
end

After do
  Timecop.return
end

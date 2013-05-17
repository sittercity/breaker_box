require 'breaker_box'
require 'timecop'
require 'breaker_box/memory_storage'

Before do
  BreakerBox.reset!
  BreakerBox.persistence_factory = PersistenceFactory
end

class PersistenceFactory
  @storage = {}

  def self.storage_for(name)
    @storage[name] ||= BreakerBox::MemoryStorage.new
  end

  def self.reset!
    @storage = {}
  end
end

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

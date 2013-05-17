require 'breaker_box/circuit'

module BreakerBox
  @breakers = {}

  def self.reset!
    @breakers = {}
  end

  def self.persistence_factory=(factory)
    @persistence_factory = factory
  end

  def self.circuit_for(circuit_name)
    @breakers[circuit_name] ||= BreakerBox::Circuit.new(@persistence_factory.storage_for(circuit_name))
  end

  def self.configure(breaker_name, options)
    circuit_for(breaker_name).options = options
  end
end

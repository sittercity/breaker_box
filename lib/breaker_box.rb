require 'breaker_box/circuit'

module BreakerBox
  @breakers = {}

  class << self
    attr_accessor :persistence_factory

    def reset!
      @breakers = {}
    end

    def circuit_for(circuit_name)
      @breakers[circuit_name] ||= BreakerBox::Circuit.new(@persistence_factory.storage_for(circuit_name))
    end

    def configure(breaker_name, options)
      circuit_for(breaker_name).options = options
    end
  end
end

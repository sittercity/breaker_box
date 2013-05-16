require 'breaker_box/circuit'

module BreakerBox
  @configuration = {}

  def self.circuit_for(circuit_name)
    BreakerBox::Circuit.new
  end

  def self.configure(breaker_name, options)
    @configuration[breaker_name] = options
  end
end

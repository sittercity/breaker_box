require 'breaker_box/circuit'

module BreakerBox
  def self.circuit_for(circuit_name)
    BreakerBox::Circuit.new
  end
end

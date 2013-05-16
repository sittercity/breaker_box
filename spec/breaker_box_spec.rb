require 'spec_helper'
require 'breaker_box'

describe BreakerBox do
  let(:breaker) { double(:breaker) }
  let(:options) { {:the => :options} }

  after :each do
    described_class.reset!
  end

  it 'generates a new breaker once' do
    BreakerBox::Circuit.should_receive(:new).once.and_return(breaker)
    described_class.circuit_for(:test).should == breaker
    described_class.circuit_for(:test).should == breaker
  end

  it 'configures a breaker' do
    breaker.should_receive(:options=).with(options)
    BreakerBox::Circuit.should_receive(:new).once.and_return(breaker)
    described_class.configure(:test, options)
  end
end

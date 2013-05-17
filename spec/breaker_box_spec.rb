require 'spec_helper'
require 'breaker_box'

describe BreakerBox do
  let(:breaker) { double(:breaker) }
  let(:options) { {:the => :options} }
  let(:persistence_factory) { double(:persistence_factory) }
  let(:test_storage) { double(:test_storage) }

  before :each do
    persistence_factory.stub(:storage_for).with(:test).and_return(test_storage)
    subject.persistence_factory = persistence_factory
  end

  after :each do
    described_class.reset!
  end

  it 'generates a new breaker once' do
    BreakerBox::Circuit.should_receive(:new).with(test_storage).once.and_return(breaker)
    described_class.circuit_for(:test).should == breaker
    described_class.circuit_for(:test).should == breaker
  end

  it 'configures a breaker' do
    breaker.should_receive(:options=).with(options)
    BreakerBox::Circuit.should_receive(:new).once.and_return(breaker)
    described_class.configure(:test, options)
  end
end

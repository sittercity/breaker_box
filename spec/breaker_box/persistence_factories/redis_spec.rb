require 'breaker_box/persistence_factories/redis'

describe BreakerBox::PersistenceFactories::Redis do

  it "returns a memory storage instance" do
    described_class.storage_for(:me).should be_a(BreakerBox::Storage::Redis)
  end

end
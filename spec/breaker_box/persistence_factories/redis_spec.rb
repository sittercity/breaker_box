require 'breaker_box/persistence_factories/redis'
require 'breaker_box/errors/empty_connection_string_error'
require 'breaker_box/errors/nil_connection_string_error'

describe BreakerBox::PersistenceFactories::Redis do

  it "raises a error when connection string is nil" do
    expect { described_class.storage_for(:me) }.to raise_error(BreakerBox::Errors::NilConnectionStringError)
  end

  it "raises a error when connection string is empty" do
    described_class.connection_string = ""
    expect { described_class.storage_for(:me) }.to raise_error(BreakerBox::Errors::EmptyConnectionStringError)
  end

  it "returns a memory storage instance" do
    described_class.connection_string = ENV["REDIS_URI"] || "redis://localhost:6379"
    described_class.reset!
    described_class.storage_for(:me).should be_a(BreakerBox::Storage::Redis)
  end

end

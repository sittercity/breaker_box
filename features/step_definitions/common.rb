Given(/^I have reset breakerbox$/) do
  BreakerBox.persistence_factory.reset! if BreakerBox.persistence_factory
  BreakerBox.reset!
end

Given(/^I have a memory persistence factory$/) do
  step 'I have reset breakerbox'
  BreakerBox.persistence_factory = BreakerBox::PersistenceFactories::Memory
end

Given(/^I have a redis persistence factory$/) do
  step 'I have reset breakerbox'
  BreakerBox::PersistenceFactories::Redis.connection_string = "redis://localhost:6379"
  BreakerBox.persistence_factory = BreakerBox::PersistenceFactories::Redis
end

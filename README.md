# breaker_box

Circuit breakers in ruby

## Usage

### Persistence Factories

First, set up a persistence factory class. You will need to map persistence classes to breaker names. Here's a simple example:

```ruby
class PersistenceFactory
  @storage = {}

  def self.storage_for(name)
    @storage[name] ||= BreakerBox::MemoryStorage.new
  end

  def self.reset!
    @storage = {}
  end
end

BreakerBox.persistence_factory = PersistenceFactory
```

The classes that `storage_for` returns must conform to the persistence interface. Specifically, the classes will need these methods:

 - `fail!`: Called when a breaker task fails
 - `clear!: Clears all previous failures
 - `all_within`: Returns an array of failures that happen within a timestamp
 - `last_failure_time`: returns the last time a failure occured on this breaker

Please looks in `BreakerBox::MemoryStorage` for an example implmentation.

### BreakerBoxes

To use a breaker box, call `BreakerBox::circuit_for(name)`. This will return a breaker that can wrap a task. Call your task with the breaker box like so:

```ruby
  breaker = BreakerBox::circuit_for(:testing)
  breaker.run SendEmail
```

#### Failure Callbacks

If a task fails and you want some action, you can assign a failure callback to a breaker:

```ruby
  breaker = BreakerBox::circuit_for(:testing)
  breaker.failure_callback = lambda { |e| Logger.alert('Email failed to send!') }
  breaker.run SendEmail
```

If you don't provide a failure callback, any exceptions raised by the task will be rethrown.

#### Breaker options

Breakers have the following default options:
  - They trip by default after two failures within two minutes
  - They retry after one hour

You can change these options by passing them into the breaker:

```ruby
  breaker.options = {:failure_threshold_count => 10, :failure_threshold_time => 240, :retry_after => 60 * 60 * 2}
```

### Tasks

Tasks are objects that do work and are passed into a breaker's `run` method. This object _must_ have a `.call` method on it (so it could be a lambda or proc). If it fails, it should raise an exception.

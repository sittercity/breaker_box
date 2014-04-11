require 'redis'
require 'multi_json'

module BreakerBox
  class RedisStorage < MemoryStorage

    def initialize(redis, key)
      @redis = redis
      @key = key
    end

    def fail!(timestamp)
      @redis.rpush(@key, timestamp.to_s)
    end

    def clear!
      @redis.del(@key)
    end

    def all_since(timestamp)
      @redis.get(@key).select {|f| timestamp < f}
    end

    def last_failure_time
      @redis.lindex(@key, -1)
    end

  end
end

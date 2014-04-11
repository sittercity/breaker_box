require 'multi_json'

module BreakerBox
  class RedisStorage < MemoryStorage

    def initialize(redis, key)
      @redis = redis
      @key = key
    end

    def fail!(timestamp)
      set_storage(get_storage.push timestamp)
    end

    def clear!
      set_storage []
    end

    def all_since(timestamp)
      get_storage.select {|f| timestamp < f}
    end

    def last_failure_time
      get_storage.last
    end

    private

    def get_storage
      value = @redis.get(@key)
      return [] unless value
      MultiJson.load value
    end

    def set_storage(value)
      @redis.set(@key, MultiJson.dump(value))
    end
  end
end

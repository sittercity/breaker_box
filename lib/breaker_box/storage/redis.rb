require 'redis'
require 'date'

module BreakerBox
  module Storage
    class Redis

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
        all_times = @redis.lrange(@key,0,-1).collect { |i| DateTime.parse(i).to_time.utc }
        all_times.select {|f| timestamp < f}
      end

      def last_failure_time
        @redis.lindex(@key, -1)
      end

    end
  end
end

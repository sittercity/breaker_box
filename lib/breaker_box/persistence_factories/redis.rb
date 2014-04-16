require 'redis'
require 'breaker_box/storage/redis'

module BreakerBox
  module PersistenceFactories
    class Redis
      class << self

        def storage_for(name)
          BreakerBox::Storage::Redis.new(redis, "#{prefix}:#{name}")
        end

        def reset!
          redis.keys("#{prefix}*").each { |k| redis.del k }
        end

        private

        def redis
          @redis ||= ::Redis.new
        end

        def prefix
          "breakerbox:storage:circuit"
        end

      end
    end
  end
end

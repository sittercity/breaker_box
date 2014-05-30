require 'redis'
require 'breaker_box/errors/nil_connection_string_error'
require 'breaker_box/storage/redis'

module BreakerBox
  module PersistenceFactories
    class Redis
      class << self

        attr_accessor :connection_string

        def storage_for(name)
          BreakerBox::Storage::Redis.new(redis, "#{prefix}:#{name}")
        end

        def reset!
          redis.keys("#{prefix}*").each { |k| redis.del k }
        end

        private

        def redis
          @redis ||= (
            if connection_string == nil
              raise BreakerBox::Errors::NilConnectionStringError.new("connection string is nil")
            elsif connection_string.empty?
              raise BreakerBox::Errors::EmptyConnectionStringError.new("connection string is empty")

            end
            ::Redis.new(:url => connection_string)
          )
        end

        def prefix
          "breakerbox:storage:circuit"
        end

      end
    end
  end
end

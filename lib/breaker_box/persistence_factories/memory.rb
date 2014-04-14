require 'breaker_box/storage/memory'

module BreakerBox
  module PersistenceFactories
    class Memory
      @storage = {}

      def self.storage_for(name)
        @storage[name] ||= BreakerBox::Storage::Memory.new
      end

      def self.reset!
        @storage = {}
      end
    end
  end
end

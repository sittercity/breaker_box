module BreakerBox
  class MemoryStorage
    def initialize
      @failures = []
    end

    def fail!(timestamp)
      @failures << timestamp
    end

    def clear!
      @failures = []
    end

    def all_since(timestamp)
      @failures.select {|f| timestamp < f}
    end

    def last_failure_time
      @failures.last
    end
  end
end

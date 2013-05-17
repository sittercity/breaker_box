module BreakerBox
  class MemoryStorage
    def initialize
      @failures = []
    end

    def fail!
      @failures << Time.now.utc
    end

    def clear!
      @failures = []
    end

    def all_within(seconds)
      @failures.select {|f| Time.now.utc - seconds < f}
    end

    def last_failure_time
      @failures.last
    end
  end
end

module BreakerBox
  class MemoryStorage
    def initialize
      @failures = []
    end

    def fail
      @failures << Time.now.utc
    end

    def all
      @failures
    end

    def clear
      @failures = []
    end
  end
end

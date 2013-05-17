module BreakerBox
  class Circuit
    def initialize(persistence)
      @state = :closed
      @persistence = persistence
      @options = {
        :open_after => 2,
        :within_seconds => 120,
        :timeout => 60 * 60 * 1, # 1 hour
      }
    end

    def run(proc_or_lambda)
      if closed? || half_open?
        begin
          proc_or_lambda.call
          reclose if half_open?
        rescue Exception => e
          fail
          if failure_callback
            failure_callback.call(e)
          else
            raise e
          end
        end
      end
    end

    def closed?
      @state == :closed
    end

    def options=(options)
      @options = @options.merge(options)
    end

    def failure_callback
      @options[:on_failure]
    end

    def failure_callback=(callback)
      @options[:on_failure] = callback
    end

    protected

    def fail
      @persistence.fail

      if pertinent_failures.count >= @options[:open_after]
        @state = :open
      end
    end

    def half_open?
      @state == :open && timeout_expired?
    end

    def pertinent_failures
      @persistence.all.select {|f| Time.now.utc - @options[:within_seconds] < f}
    end

    def timeout_expired?
      failed_at + @options[:timeout] < Time.now.utc
    end

    def failed_at
      @persistence.all.last
    end

    def reclose
      @state = :closed
      @persistence.clear
    end
  end
end

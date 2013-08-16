module BreakerBox
  class Circuit
    def initialize(persistence)
      @persistence = persistence
      @options = {
        :failure_threshold_count => 2,
        :failure_threshold_time => 120,
        :retry_after => 60 * 60 * 1, # 1 hour
      }
    end

    def run(proc_or_lambda)
      if closed? || half_open?
        begin
          response = proc_or_lambda.call
          reclose if half_open?
        rescue Exception => e
          fail
          if failure_callback
            response = failure_callback.call(e)
          else
            raise e
          end
        end
        response
      end
    end

    def closed?
      state == :closed
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

    def state
      if pertinent_failures.count >= @options[:failure_threshold_count]
        :open
      else
        :closed
      end
    end

    def fail
      @persistence.fail!(Time.now.utc)
    end

    def half_open?
      state == :open && timeout_expired?
    end

    def pertinent_failures
      @persistence.all_since(Time.now.utc - @options[:failure_threshold_time])
    end

    def timeout_expired?
      failed_at + @options[:retry_after] < Time.now.utc
    end

    def failed_at
      @persistence.last_failure_time
    end

    def reclose
      @persistence.clear!
    end
  end
end

module BreakerBox
  class Circuit
    class StateMachine
      attr_reader :state
      def initialize(state)
        @state = state
      end

      def closed?
        @state == :closed
      end

      def close!
        @state = :closed
      end

      def open?
        @state == :open
      end

      def open!
        @state = :open
      end
    end

    attr_accessor :failure_callback

    def initialize(state_machine=StateMachine.new(:closed), failures=[])
      @state_machine = state_machine
      @failures = failures
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
          failure_callback.call(e) if failure_callback
        end
      end
    end

    def closed?
      @state_machine.closed?
    end

    def options=(options)
      @options = @options.merge(options)
      @failure_callback = options[:on_failure] if options[:on_failure]
    end

    protected

    def fail
      @failures << Time.now.utc

      if pertinent_failures.count == @options[:open_after]
        @state_machine.open!
      end
    end

    def half_open?
      @state_machine.open? && timeout_expired?
    end

    def pertinent_failures
      @failures.select {|f| Time.now.utc - @options[:within_seconds] < f}
    end

    def timeout_expired?
      last_failed_at + @options[:timeout] < Time.now.utc
    end

    def last_failed_at
      @failures.last
    end

    def reclose
      @state_machine.close!
      @failures.clear
    end
  end
end

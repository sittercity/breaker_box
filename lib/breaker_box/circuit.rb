module BreakerBox
  class Circuit

    attr_accessor :failure_callback

    def run(proc_or_lambda)
      begin
        proc_or_lambda.call
      rescue Exception => e
        failure_callback.call(e)
      end
    end

    def closed?
      true
    end
  end
end

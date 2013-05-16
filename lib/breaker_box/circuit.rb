module BreakerBox
  class Circuit
    def run(proc_or_lambda)
      proc_or_lambda.call
    end

    def closed?
      true
    end
  end
end

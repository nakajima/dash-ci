module CI
  # Acts as target for Dash instrumentation
  class InstrumentTarget
    class << self
      attr_accessor :suites
    end

    # Run each of the build's suites, calling the appropriate instrumented
    # method for each respective outcome.
    def build!
      suites.each { |suite| send(CI.clean(suite)) } ; finish!
    end
    
    # Instrumented methods
    def fail!(suite)
      puts "Suite failed: #{suite}"
    end
    
    def green!(suite)
      puts "Suite passed: #{suite}"
    end
    
    # Ensure data gets reported back to FiveRuns before process exits.
    def finish!
      session.report!
    end
    
    private
    
    def suites
      self.class.suites
    end
    
    def reporter
      session.reporter
    end
    
    def session
      @session ||= Session.new
    end
  end
end
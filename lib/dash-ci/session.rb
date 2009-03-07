module CI
  # Provide wrapper around dash-ruby session in order to be able to send
  # data to FiveRuns when suites complete instead of relying on periodic
  # update to finish.
  class Session
    def initialize
      @session = Fiveruns::Dash.send(:session)
    end
  
    def report!
      reporter.send :send_data_update
    end
  
    private
  
    def reporter
      @reporter ||= begin
        @session.reporter.secure!
        @session.reporter
      end
    end
  end
end
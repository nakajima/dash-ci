# CI.register(:my_awesome_app) do
#   build :rspec, 'rake spec'
#   build :cucumber, 'cucumber features/'
#   build :selenium, 'rake selenium:test'
# end

# CI.run(:my_awesome_app)

require 'rubygems'
require 'fiveruns/dash'

class CI
  class BrokenBuild < StandardError ; end
  
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

  # Acts as target for Dash instrumentation
  class InstrumentTarget
    class << self
      attr_accessor :suites
    end

    def build!
      self.class.suites.each do |suite|
        puts "Building #{suite}..."
        send(suite)
      end
      
      green!
    end
    
    def green!
      puts "Builded successfully."
      session.report!
    end

    def fail!(suite)
      session.report!
      raise BrokenBuild.new("Build failed during: #{suite}")
    end
    
    def reporter
      session.reporter
    end
    
    def session
      @session ||= Session.new
    end
  end

  class << self
    def register(sym, &block)
      klass = Class.new(InstrumentTarget) 
      klass.suites = []
      CI.const_set(sym.to_s.capitalize, klass)
      new(klass).instance_eval(&block)
    end

    def run(sym, options={})
      klass = CI.const_get(sym.to_s.capitalize)
      make_recipe(klass, options)
      klass.new.build!
    end

    def make_recipe(klass, options)
      puts "Generating recipe..."
      
      Fiveruns::Dash.register_recipe options[:as], :url => 'http://dash.ci' do |recipe|
        klass.suites.each do |suite|
          puts '  - adding %s' % suite
          recipe.time suite, :method => instrument(klass, suite)
        end

        recipe.counter :total_builds, :incremented_by => instrument(klass, 'build!')
        recipe.counter :green_builds, :incremented_by => instrument(klass, 'green!')
        recipe.counter :broken_builds, :incremented_by => instrument(klass, 'fail!')
      end
      
      Fiveruns::Dash.logger = Logger.new(STDERR)
      
      Fiveruns::Dash.start :app => options[:token] do |config|
        config.add_recipe options[:as]
      end
    end
    
    def instrument(klass, sym)
      '%s#%s' % [klass.to_s, sym]
    end
  end

  def initialize(klass)
    @klass = klass
  end

  def build(suite, command)
    @klass.suites << suite
    @klass.class_eval do
      define_method(suite) do
        system(command) or fail!(suite)
      end
    end
  end
end
module CI
  class Base
    class << self
      # Generate a new class that will have methods generated for it which
      # Dash will then instrument.
      def register(sym, &block)
        klass = Class.new(InstrumentTarget) 
        klass.suites = []
        CI.set(sym, klass)
        new(klass).instance_eval(&block)
      end

      # Run a set of suites that correspond with a given generated recipe.
      # This method is called after .register().
      def run(sym, options={})
        klass = CI.get(sym)
        make_recipe(klass, CI.clean(sym), options)
        klass.new.build!
      end

      # Generate Dash recipe from suite commands passed to the .register()
      # block, then start Dash.
      def make_recipe(klass, recipe, options)
        puts "Generating recipe..."

        Fiveruns::Dash.register_recipe recipe, :url => 'http://dash.ci' do |recipe|
          klass.suites.each do |suite|
            puts '  - adding %s' % suite
            method_id = instrument(klass, CI.clean(suite))
            recipe.time CI.clean(suite), :method => method_id
          end

          recipe.time    :total_time,   :method => 'CI.run'
          recipe.counter :total_builds, :incremented_by => instrument(klass, 'finish!')
          recipe.counter :green_builds, :incremented_by => instrument(klass, 'green!')
          recipe.counter :broken_builds, :incremented_by => instrument(klass, 'fail!')
        end

        Fiveruns::Dash.logger = Logger.new \
          options[:verbose] ? STDERR : StringIO.new("")

        Fiveruns::Dash.start :app => options[:token] do |config|
          config.add_recipe recipe
        end
      end

      private

      def instrument(klass, sym)
        '%s#%s' % [klass.to_s, sym]
      end
    end

    def initialize(klass)
      @klass = klass
    end

    # Define a method on the instrument class for Dash to monkey-patch. The
    # method corresponds to a system command that will run that suite, for
    # example:
    #
    #   CI.register(:fixjour) do
    #     build :specs, 'spec spec/'
    #   end
    #
    # When the command is run and exits without error, the suite passes.
    def build(suite, command)
      @klass.suites << suite
      @klass.class_eval do
        define_method(CI.clean(suite)) do
          system(command) or raise(BrokenBuild.new('%s suite failed.' % suite))
        end
      end
    end
  end
end
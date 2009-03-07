# CI.register(:my_awesome_app) do
#   build :rspec, 'rake spec'
#   build :cucumber, 'cucumber features/'
#   build :selenium, 'rake selenium:test'
# end

# CI.run(:my_awesome_app)

require 'rubygems'
require 'fiveruns/dash'
require 'base'
require 'target'
require 'session'

module CI
  # 
  class BrokenBuild < StandardError ; end
  
  class << self
    # Register a new recipe, declaring the suite it measures in the block.
    # The actual Dash recipe generation doesn't happen until run() though.
    def register(sym, &block)
      Base.register(sym, &block)
    end

    # Find the instrument target class for the given recipe, generate Dash
    # recipe for suite, start Dash.
    def run(sym, options={})
      Base.run(sym, options)
    end
    
    # Sanitize name to be passed around to indicate a suite.
    def clean(sym)
      sym.to_s.gsub(/\W/, '_')
    end
    
    # Get an instrument target class.
    def get(sym)
      CI.const_get(clean(sym).capitalize)
    end
    
    # Set an instrument target class.
    def set(sym, klass)
      CI.const_set(clean(sym).capitalize, klass)
    end
  end
end
require 'rubygems'
require 'spec'
require 'rr'

require File.dirname(__FILE__) + '/../lib/dash_ci'

Spec::Runner.configure { |c| c.mock_with(:rr) }
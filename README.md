# Dash CI

Metrics for continuous integration with FiveRuns Dash. Still pretty raw.

## Usage (probably)

    require 'rubygems'
    require 'dash-ci'

    # First define what your build does
    CI.register(:my_ci_build) do
      build :specs, 'spec spec/'
      build :selenium, 'script/selenium run'
      build :cucumber, 'cucumber features/'
    end

    # Then run it
    CI.run(:my_ci_build, :token => 'MY-DASH-TOKEN')

`(c) Copyright 2009 Pat Nakajima, released under MIT License.`
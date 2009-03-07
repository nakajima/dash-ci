# Dash CI

Metrics for continuous integration with FiveRuns Dash ([dash.fiveruns.com](http://dash.fiveruns.com)). Still pretty raw.

## Usage (probably)

See [`ci.rb`](http://github.com/nakajima/sinatras-hat/blob/ac40b9585b4f0d8e00d0448b7b9fecfc267726f7/ci.rb) in my Sinatra's Hat project for how it's really used.

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
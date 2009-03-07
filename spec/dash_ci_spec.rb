require 'spec/spec_helper'

describe DashCi do
  it "should exist" do
    proc {
      DashCi
    }.should_not raise_error
  end
end
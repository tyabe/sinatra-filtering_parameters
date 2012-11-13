require 'spec_helper'
require 'sinatra/filtering_parameters'

describe Sinatra::FilteringParameters do
  it "should have a VERSION constant" do
    subject.const_get('VERSION').should_not be_empty
  end
end

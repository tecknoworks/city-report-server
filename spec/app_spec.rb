require 'spec_helper'

describe Repara do
  it 'knows it\'s running in the test env' do
    Repara.config['env'].should == 'test'
  end
end

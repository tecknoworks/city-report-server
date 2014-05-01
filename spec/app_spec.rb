require 'spec_helper'

describe Repara do
  it 'should know about test env' do
    Repara.config['env'].should == 'test'
  end
end

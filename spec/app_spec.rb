require 'spec_helper'

describe Repara do
  it 'knows it\'s running in the test env' do
    Repara.config['env'].should == 'test'
  end

  # used in tests
  it 'has at least 3 categories' do
    Repara.categories.count >= 3
  end
end

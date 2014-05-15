require 'spec_helper'

describe BaseController do
  it 'knows it\'s running in the test env' do
    app.settings.environment.should == :test
    app.settings.config['env'].should == 'test'
  end
end

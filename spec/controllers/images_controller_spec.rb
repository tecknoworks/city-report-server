require 'spec_helper'

describe ImagesController do
  it 'should run in test env' do
    app.settings.environment.should == :test
    app.settings.config['env'].should == 'test'
  end
end

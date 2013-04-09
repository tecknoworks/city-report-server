require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'sinatra'
require 'rack/test'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

def test_config_path
  'spec/thin.yml'
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.before(:each) {
    config_file = DbWrapper.read_config(test_config_path)

    DbWrapper.stub(:read_config).and_return(config_file)
    DbWrapper.any_instance.stub(:config).and_return(config_file)
  }
  config.after(:each) {
    config_file = DbWrapper.read_config(test_config_path)

    Dir[config_file['image_upload_path'] + '/*.png'].each do |i|
      `rm #{i}`
    end

    db_wrap = DbWrapper.new(test_config_path)
    db_wrap.db['issues'].remove
  }
end

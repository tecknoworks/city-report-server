require 'yaml'
require 'json'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

class BaseController < Sinatra::Base
  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
  end

  configure :development do
    register Sinatra::Reloader
  end
end

class WelcomeController < BaseController
  get '/' do
    settings.config['foo'].to_json
  end

  get '/meta' do
    settings.config['meta'].to_json
  end

  get '/doc' do
  end
end

class IssuesController < BaseController
  get '/' do
    'issues'
  end

  post '/' do
    'issues'
  end
end

class ImagesController < BaseController
  post '/' do
    'images'
  end
end

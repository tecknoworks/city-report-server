require 'yaml'
require 'json'
require 'haml'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

class BaseController < Sinatra::Base
  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
    set :public, 'public'

    use Rack::Static, :urls => ['/javascripts', '/sylesheets', '/images'], :root => 'public'
  end

  configure :development do
    register Sinatra::Reloader
  end
end

class WelcomeController < BaseController
  get '/' do
    haml :index
  end

  get '/doc' do
    haml :doc
  end

  get '/upload' do
    haml :upload
  end

  get '/meta' do
    settings.config['meta'].to_json
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

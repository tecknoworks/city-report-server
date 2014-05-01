class BaseController < Sinatra::Base
  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
    set :public, 'public'
    set :root, File.join(File.dirname(__FILE__), '..')

    use Rack::Static, :urls => ['/javascripts', '/sylesheets', '/images'], :root => 'public'
  end

  configure :development do
    register Sinatra::Reloader
  end
end

class BaseController < Sinatra::Base
  helpers do
    include BaseHelper
  end

  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
    CONFIG = settings.config
    set :public_folder, 'public'
    set :root, File.join(File.dirname(__FILE__), '..')

    enable :logging
    file = File.new("#{Dir.pwd}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file

    register Sinatra::MultiRoute
  end

  configure :development do
    register Sinatra::Reloader
  end
end

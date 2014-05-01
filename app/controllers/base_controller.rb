class BaseController < Sinatra::Base
  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
    set :public_folder, 'public'
    set :root, File.join(File.dirname(__FILE__), '..')
  end

  configure :development do
    register Sinatra::Reloader
  end
end

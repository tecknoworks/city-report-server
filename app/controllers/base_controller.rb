class BaseController < Sinatra::Base

  helpers do
    include Sinatra::ContentFor
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

  def json?
    request.content_type == 'application/json'
  end

  def issues_search_results
    limit = params['limit'].nil? ? 10 : params['limit']
    skip = params['skip'].nil? ? 0 : params['skip']
    query = params['q']

    Issue.order_by([:created_at, :desc]).limit(limit).skip(skip).full_text_search(query)
  end
end

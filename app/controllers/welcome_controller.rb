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

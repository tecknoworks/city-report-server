class WelcomeController < BaseController
  get '/' do
    haml :index
  end

  get '/doc' do
    haml :doc
  end

  get '/up' do
    haml :upload
  end

  get '/meta' do
    settings.config['meta'].to_json
  end
end

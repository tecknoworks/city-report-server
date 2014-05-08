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

  get '/eula' do
    haml :eula
  end

  get '/about' do
    haml :about
  end
end

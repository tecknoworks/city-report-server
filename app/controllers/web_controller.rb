class WebController < BaseController
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

  get '/stats' do
    @issues_by_category = {}
    Repara.categories.each do |category|
      @issues_by_category[category] = Issue.where(category: category).count
    end
    haml :stats
  end
end

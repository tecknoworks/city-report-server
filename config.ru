require 'bundler'
Bundler.require(:default)

require './app/app'
require 'sidekiq/web'

use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| ::MultiJson.decode body }
}

map '/' do
  run WebController
end

map '/meta' do
  run MetaController
end

map '/issues' do
  run IssuesController
end

map '/upload' do
  run ImagesController
end

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

map '/sidekiq' do
  run Sidekiq::Web
end

require 'bundler'
Bundler.require(:default)

require './app/app'

use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| ::MultiJson.decode body }
}

map '/' do
  run WelcomeController
end

map '/issues' do
  run IssuesController
end

map '/upload' do
  run ImagesController
end

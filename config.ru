require 'bundler'
Bundler.require(:default)

require './app/app'

map '/' do
  run WelcomeController
end

map '/issues' do
  run IssuesController
end

map '/upload' do
  run ImagesController
end

require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require './db_wrapper'

db_wrap = DbWrapper.new('thin.yml')

get '/' do
  haml :index
end

get '/issues' do
  content_type :json
  db_wrap.issues
end

post '/issues' do
  content_type :json
  db_wrap.insert params
end

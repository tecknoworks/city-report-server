require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require 'rack/parser'

require './db_wrapper'
require './helpers'

use Rack::Parser

db_wrap = DbWrapper.new('thin.yml')

get '/' do
  haml :index
end

get '/issues' do
  content_type :json
  db_wrap.issues.to_json
end

post '/issues' do
  content_type :json

  validation_error = valid? params
  return validation_error if validation_error.class != TrueClass

  db_wrap.save_image(params)
  db_wrap.create_issue(params).to_json
end

put '/issues' do
  content_type :json
end

get '/upload' do
  haml :upload
end

delete '/issues' do
  db_wrap.db['issues'].remove
end

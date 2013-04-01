require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require './db_wrapper'

db_wrap = DbWrapper.new('thin.yml')

def render_error msg, code=400
  return {'code' => code, 'message' => msg}.to_json
end

get '/' do
  haml :index
end

get '/issues' do
  content_type :json
  db_wrap.issues.to_json
end

post '/issues' do
  ['lat', 'lon', 'title'].each do |param|
    unless params[param]
      status 400
      return render_error "#{param} param missing"
    end
  end

  content_type :json
  db_wrap.create_issue params
end

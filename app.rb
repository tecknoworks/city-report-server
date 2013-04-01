require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require './db_wrapper'

db_wrap = DbWrapper.new('thin.yml')

def do_render msg, code=200
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
      return do_render("#{param} param missing", 400)
    end
  end

  content_type :json
  db_wrap.create_issue(params).to_json
end

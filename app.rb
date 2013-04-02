require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require './db_wrapper'
require 'rack/parser'

use Rack::Parser

db_wrap = DbWrapper.new('thin.yml')

def do_render msg, code=200
  status code
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
      return do_render("#{param} param missing", 400)
    end
  end

  content_type :json
  db_wrap.create_issue(params).to_json
end

delete '/issues' do
  if development?
    db_wrap.db['issues'].remove
    return do_render("done")
  else
    return do_render("method not allowed", 405)
  end
end

require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require 'rack/parser'

require './db_wrapper'

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
  content_type :json

  ['lat', 'lon', 'title'].each do |param|
    unless params[param]
      return do_render("#{param} param missing", 400)
    end
  end

  if params['title'].length > 141
    return do_render("title can not be longer than 141 chars", 400)
  end

  db_wrap.save_image(params)
  db_wrap.create_issue(params).to_json
end

get '/upload' do
  haml :upload
end

delete '/issues' do
  if development?
    db_wrap.db['issues'].remove
    return do_render("done")
  else
    return do_render("method not allowed", 405)
  end
end

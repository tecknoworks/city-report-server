require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'

config = YAML.load_file('thin.yml')
client = Mongo::MongoClient.new(config['db_host'], config['db_port'])
db = client[config['db_name']]

get '/' do
  haml :index
end

get '/issues' do
  content_type :json
  db['issues'].find.collect{ |row| row }.to_s
end

post '/issues' do
  content_type :json
  db['issues'].insert params
end

post '/images' do
end

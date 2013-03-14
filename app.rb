require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/respond_to'
require 'json'
require 'yaml'
require 'mongo'

Sinatra::Application.register Sinatra::RespondTo
config = YAML.load_file('thin.yml')
client = Mongo::MongoClient.new(config['db_host'], config['db_port'])
db = client[config['db_name']]

get '/' do
  respond_to do |wants|
    wants.html { haml :index }
    wants.json { db['issues'].find.collect{ |row| row }.to_s }
  end
end

post '/issue' do
  content_type :json
  db['issues'].insert params
end

post '/image' do
end

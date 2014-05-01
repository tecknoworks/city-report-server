require 'yaml'
require 'json'
require 'haml'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

require './app/controllers/base_controller'
require './app/controllers/welcome_controller'
require './app/controllers/issues_controller'
require './app/controllers/images_controller'

require 'yaml'
require 'json'
require 'haml'
require 'mongoid'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'

require './app/models/issue'
require './app/repara_helper'
require './app/controllers/base_controller'
require './app/controllers/welcome_controller'
require './app/controllers/issues_controller'
require './app/controllers/images_controller'

class Repara
  def self.config
    BaseController::CONFIG
  end
end

Mongoid.load!("config/mongoid.yml")

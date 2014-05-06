require 'yaml'
require 'json'
require 'haml'
require 'mongoid'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'
require 'sinatra/json'

require './app/models/issue'
require './app/repara_helper'
require './app/controllers/base_controller'
require './app/controllers/welcome_controller'
require './app/controllers/issues_controller'
require './app/controllers/images_controller'

require './app/workers/thumbnail_worker'
require './app/workers/geocode_worker'

class Repara
  def self.config
    BaseController::CONFIG
  end

  def self.categories
    self.config['meta']['categories']
  end
end

I18n.enforce_available_locales = false
Mongoid.load!("config/mongoid.yml")

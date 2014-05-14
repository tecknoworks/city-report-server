require 'uri'
require 'yaml'
require 'json'
require 'haml'
require 'mongoid'
require 'mongoid_search'
require 'httparty'
require 'sidekiq'
require 'micro_magick'

require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/config_file'
require 'sinatra/json'
require 'sinatra/multi_route'

require './app/helpers/base_helper'
require './app/helpers/repara_helper'

require './app/lib/geocoder'
require './app/lib/request_codes'

require './app/models/base_model'
require './app/models/issue'
require './app/models/image'

require './app/controllers/base_controller'
require './app/controllers/meta_controller'
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

  def self.base_url
    self.config['base_url']
  end

  def self.string_max_length
    self.config['string_max_length']
  end

  def self.name_max_length
    string_max_length['name']
  end

  def self.comments_max_length
    string_max_length['comments']
  end

  def self.address_max_length
    string_max_length['address']
  end
end

I18n.enforce_available_locales = false
Mongoid.load!("config/mongoid.yml")
Mongoid::Search.setup do |config|
  config.match = :any

  ## If true, an empty search will return all objects
  config.allow_empty_search = true

  ## If true, will search with relevance information
  #config.relevant_search = false

  ### Stem keywords
  #config.stem_keywords = false

  ### Add a custom proc returning strings to replace the default stemmer
  ## For example using ruby-stemmer:
  ## config.stem_proc = Proc.new { |word| Lingua.stemmer(word, :language => 'nl') }

  ### Words to ignore
  #config.ignore_list = []

  ### An array of words
  ## config.ignore_list = %w{ a an to from as }

  ### Or from a file
  ## config.ignore_list = YAML.load(File.open(File.dirname(__FILE__) + '/config/ignorelist.yml'))["ignorelist"]

  ### Search using regex (slower)
  #config.regex_search = true

  ### Regex to search

  ### Match partial words on both sides (slower)
  #config.regex = Proc.new { |query| /#{query}/ }

  ### Match partial words on the beginning or in the end (slightly faster)
  ## config.regex = Proc.new { |query| /ˆ#{query}/ }
  ## config.regex = Proc.new { |query| /#{query}$/ }

  ## Ligatures to be replaced
  ## http://en.wikipedia.org/wiki/Typographic_ligature
  #config.ligatures = { "œ"=>"oe", "æ"=>"ae" }

  ## Minimum word size. Words smaller than it won't be indexed
  config.minimum_word_size = 2
end

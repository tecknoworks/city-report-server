require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require 'rack/parser'
require 'httparty'

use Rack::Parser

require './app/util'
require './app/geocoder'
require './app/db_wrapper'
require './app/helpers'
require './app/routes'

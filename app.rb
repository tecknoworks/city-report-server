require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'yaml'
require 'mongo'
require 'rack/parser'
use Rack::Parser

require './app/db_wrapper'
require './app/helpers'
require './app/routes'

require 'rack/test'

ENV['RACK_ENV'] = 'test'

require './app/app'

class BaseController < Sinatra::Base
  configure do
    set :environment, :test
  end
end

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

require 'sidekiq/testing'
Sidekiq::Logging.logger = nil

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.include RSpecMixin

  I18n.config.enforce_available_locales = true

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

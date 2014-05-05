class BaseController < Sinatra::Base
  helpers do
    def generate_upload_response storage_filename
      {
        url: base_url + 'images/uploads/' + storage_filename,
        thumbUrl: base_url + 'images/uploads/' + storage_filename
      }.to_json
    end

    def base_url
      settings.config['base_url']
    end

    def pretty_json h
      JSON.pretty_generate(JSON.parse(h))
    end
  end

  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
    CONFIG = settings.config
    set :public_folder, 'public'
    set :root, File.join(File.dirname(__FILE__), '..')
  end

  configure :development do
    register Sinatra::Reloader
  end
end

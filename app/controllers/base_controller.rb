class BaseController < Sinatra::Base
  helpers do
    def generate_upload_response storage_filename
      {
        url: settings.config['base_url'] + 'images/uploads/' + storage_filename,
        thumbUrl: settings.config['base_url'] + 'images/uploads/' + storage_filename
      }.to_json
    end
  end

  configure do
    set :config, YAML.load_file('config/config.yml')[settings.environment.to_s]
    set :public_folder, 'public'
    set :root, File.join(File.dirname(__FILE__), '..')
  end

  configure :development do
    register Sinatra::Reloader
  end
end

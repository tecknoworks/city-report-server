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

    def generate_error code, desc, errors=nil
      status code
      json(generate_error_without_changing_status(code, desc, errors))
    end

    def generate_error_without_changing_status code, desc, errors=nil
      errors = desc if errors.nil?
      {
        'code' => code,
        'desc' => desc,
        'errors' => errors
      }
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

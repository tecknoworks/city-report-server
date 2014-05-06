class BaseController < Sinatra::Base
  helpers do
    def base_url
      settings.config['base_url']
    end

    def pretty_json h
      JSON.pretty_generate(JSON.parse(h))
    end

    def generate_upload_response storage_filename
      {
        url: base_url + 'images/uploads/' + storage_filename
      }
    end

    def render_response body, code=200, status_code=nil
      status_code ||= code
      status status_code
      json(render_response_without_changing_status(body, code))
    end

    def render_response_without_changing_status body, code=200
      {
        code: code,
        body: body
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

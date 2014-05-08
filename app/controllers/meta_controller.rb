class MetaController < BaseController
  get '/' do
    Repara.config['meta'].to_json
  end
end

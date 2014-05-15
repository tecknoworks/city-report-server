require 'spec_helper'

describe MetaController do
  context 'get' do
    it 'returns the meta data in config.yml' do
      get '/'
      last_response.should be_ok
      json_data = JSON.parse(last_response.body)
      json_data.should == app.settings.config['meta']
    end
  end
end

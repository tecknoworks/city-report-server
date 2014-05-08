require 'spec_helper'

describe MetaController do
  it 'should allow the meta requests' do
    get '/'
    last_response.should be_ok
    json_data = JSON.parse(last_response.body)
    json_data.should == app.settings.config['meta']
  end
end

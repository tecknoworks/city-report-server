require 'spec_helper'

describe BannedIpsController, type: :controller do
  it 'works' do
    get :index
    response.status.should eq RequestCodes::SUCCESS
  end
end
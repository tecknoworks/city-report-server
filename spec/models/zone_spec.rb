require 'spec_helper'

describe Zone do
  let(:zone) { create :zone }

  it 'has to_api' do
    zone
    Zone.to_api.should eq Zone.all.collect{ |zone| zone.name }
  end
end

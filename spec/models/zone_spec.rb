require 'spec_helper'

describe Zone do
  let(:zone) { create :zone }

  it { expect(subject).to validate_presence_of :name }

  it 'has to_api' do
    zone
    Zone.to_api.should eq Zone.all.collect(&:name)
  end
end

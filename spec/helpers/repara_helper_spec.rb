require 'spec_helper'

describe ReparaHelper do
  include ReparaHelper

  context '#serialize_filename' do
    it 'converts a filename to a unique filename' do
      time_now = Time.parse("Apr 29 1989")
      Time.stub(:now).and_return(time_now)
      serialize_filename('test.png').should == '609800400.000000000-test.png'
    end
  end
end

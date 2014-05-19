require 'spec_helper'

describe Geocoder do
   context "#kung_foo" do
     it "geocodes" do
       # this can change
       expected_result = 'Strada Șerpuitoare 39, Cluj-Napoca 400000, Romania'
       Geocoder.kung_foo(46.77484, 23.576).should == expected_result
     end
   end
end

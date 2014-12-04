module Requests
  # http://dhartweg.roon.io/rspec-testing-for-a-json-api
  module JsonHelpers
    def json
      @json = JSON.parse(response.body)
      @json = @json.with_indifferent_access if @json.class == Hash
      @json
    end
  end
end

require 'spec_helper'

describe Curator do
  subject (:curator) { Curator.new }

  context '#find_duplicate_coordinates' do
    it 'has the find_duplicate_coordinates method' do
      expect(curator).to respond_to :find_duplicate_coordinates
    end
    
    it 'returns an array' do
      expect(curator.find_duplicate_coordinates("groapa", 0, 0)).to be_empty
    end

    it 'finds exact duplicate coordinates' do
      issue1 = create :issue
      issue2 = create :issue, lat: issue1.lat, lon: issue1.lon

      result = curator.find_duplicate_coordinates("category1", issue2.lat, issue2.lon)

      expect(result).to include(issue1)
      expect(result).to include(issue2)
    end
  end

  context 'duplicate text' do
  end

  context 'overlapping coordinates' do
  end
end

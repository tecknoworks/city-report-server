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
      Issue.delete_all
      issue1 = create :issue, category: "category1"
      issue2 = create :issue, lat: issue1.lat, lon: issue1.lon, category: "category1"
        
      result = curator.find_duplicate_coordinates("category1", issue2.lat, issue2.lon)
      
      expect(result).to include(issue1)
      expect(result).to include(issue2)
    end
    
    it 'finds aprox. coordinates' do
      Issue.delete_all
      issue1 = create :issue, lat: 46.772294181082366, lon: 23.59893724322319, category: "category1"
      issue2 = create :issue, lat: 46.772294181080000, lon: 23.59893724300000, category: "category1"
      issue3 = create :issue, lat: 46.772294181040000, lon: 23.59893724340000, category: "category1"
      issue4 = create :issue, lat: 46.782294181082366, lon: 23.59893724322319, category: "category1"
      issue5 = create :issue, lat: 46.782294181082366, lon: 23.49893724322319, category: "category1"
     
      lat = 46.772294181082366   
      lon = 23.59893724322319
      
      result = curator.find_duplicate_coordinates("category1", lat, lon);

      expect(result).to include(issue1)
      expect(result).to include(issue2)
      expect(result).to include(issue3) 
      expect(result).to_not include(issue4)
      expect(result).to_not include(issue5)

      result = curator.find_duplicate_coordinates("category2", lat, lon);
      
      expect(result.size).to eq 0      
          
    end
  end

  context 'duplicate text' do
  end

  context 'overlapping coordinates' do
  end
end
   
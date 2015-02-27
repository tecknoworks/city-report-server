require 'spec_helper'

describe do
  def in_circle(center_lat, center_lon, radius, lat, lon)
    square_dist = (center_lat - lat) ** 2 + (center_lon - lon) ** 2
    return square_dist <= radius ** 2
  end

  def radius(lat, lon, dist_lat, dist_lon)
    km_lat = 0.00664115 * dist_lat
    km_lon = 0.004530219 * dist_lon

    Issue.where({
      :lat.lt => lat+km_lat,
      :lat.gt => lat - km_lat,
      :lon.lt => lon + km_lon,
      :lon.gt => lon - km_lon
    })
    #    issues = Issue.all.geo_near(coordinates, [ 50, 13 ])
  end

  it "appropriate points" do
    Issue.delete_all
    expect {
      issue1 = create :issue, name: "Avram", lat: 46.77127690853819, lon: 23.59675459563732
      issue2 = create :issue, name: "Parcul operei", lat: 46.769444850967666, lon: 23.597911298274994
      issue3 = create :issue, name: "Piata uniri", lat: 46.76966301100376, lon: 23.58986735343933
      issue4 = create :issue, name: "Gara", lat: 46.784666167409505, lon: 23.588457852602005
      issue5 = create :issue, name: "Cimitir Central", lat: 46.76444254340392, lon: 23.593038395047188
      issue6 = create :issue, name: "Sens Giratoriu Marasti", lat: 46.7783276130512, lon: 23.61467309296131
      issue7 = create :issue, name: "Simion Barnutiu", lat: 46.77338904798552, lon: 23.607473373413086
      issue8 = create :issue, name: "Ubb", lat: 46.76741063833104, lon: 23.591589331626892
      issue9 = create :issue, name: "Lacul 3", lat: 46.77465610819743, lon: 23.632176518440247
      issue10 = create :issue, name: "Lac ghiorgheni", lat: 46.77384600137202, lon: 23.625378459692
      expect(issue1.lat).to eq 46.77127690853819
    }.to change { Issue.count}.by(10)
    expect(radius(46.77066286159022, 23.596578240394592, 1, 1).count).to eq 3
    expect(radius(46.77066286159022, 23.596578240394592, 1, 1).count).to eq 3
    expect(radius(46.77127690853819, 23.658628463745117, 1, 1).count).to eq 0
    expect(radius(46.77064449059386, 23.59675459563732, 1, 1).count).to eq  3
    expect(radius(46.77064449059386, 23.59675459563732, 10, 10).count).to eq 10
    expect(radius(46.77064449059386, 23.59675459563732, 10, 0).count).to eq 0
  end

  #verif. in ce cartier este un issue

  def get_neighborhood(issue)
    info_zone = Geocoder.get_info_zone(issue[:lat], issue[:lon])['results'][1]['address_components'][0]["long_name"]
  end

  it 'return neighborhood for issue' do
    issue1 = create :issue, name: "C Marasti", lat: 46.77603059830436, lon: 23.60835313796997
    expect(get_neighborhood(issue1).to_s).to eq "Mărăști"
    
    issue2 = create :issue, name: "C Ghiorgheni", lat: 46.76527989160337, lon: 23.625540733337402
    expect(get_neighborhood(issue2).to_s).to eq "Gheorgheni"
    
    issue3 = create :issue, name: "C Zorilor", lat: 46.75604859137965, lon: 23.585715293884277
    expect(get_neighborhood(issue3).to_s).to eq "Zorilor"
    
    issue4 = create :issue, name: "C Manastur", lat: 46.758238963369145, lon: 23.55118989944458
    expect(get_neighborhood(issue4).to_s).to eq "Mănăștur"
  end
end
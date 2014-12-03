# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['groapă', 'gunoi', 'vandalism', 'altele'].each do |cat|
  Category.where(name: cat).first_or_create
end

[
  'Andrei Mureșanu',
  'Bulgaria',
  'Bună Ziua',
  'Centru',
  'Dâmbul Rotund',
  'Gara',
  'Gheorgheni',
  'Grădini Mănăștur',
  'Grigorescu',
  'Gruia',
  'Hidelve',
  'Iris',
  'Între Lacuri',
  'Mănăștur',
  'Mărăști',
  'Someșeni',
  'Zorilor',
  'Sopor',
  'Borhanci',
  'Becaș',
  'Făget',
  'Zorilor sud (Europa)',
  'Lomb',
  'Tineretului',
  'Pata-Rât'
].each do |zone|
  Zone.where(name: zone).first_or_create
end

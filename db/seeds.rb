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

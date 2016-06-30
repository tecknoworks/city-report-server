json.code 200
json.body do |json|
  json.url @image.url
  json.thumb_url @image.thumb_url
  json.resized_url @image.resized_url
end

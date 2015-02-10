json.code 200
json.body do |json|
  json.partial! 'banned_ip', banned_ip: @banned_ip
end
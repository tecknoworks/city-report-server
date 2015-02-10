json.code 200
json.body do |json|
  json.partial! 'banned_ip', collection: @banned_ips, as: :banned_ip
end

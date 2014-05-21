json.code 200
json.body do |json|
  json.partial! 'issue', issue: @issue
end

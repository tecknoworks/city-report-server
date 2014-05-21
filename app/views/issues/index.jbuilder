json.code @status_code || 200
json.body do |json|
  json.partial! 'issue', collection: @issues, as: :issue
end

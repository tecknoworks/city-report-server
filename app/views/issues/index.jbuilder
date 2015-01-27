json.code @status_code || RequestCodes::SUCCESS
json.body do |json|
  json.partial! 'issue', collection: @issues, as: :issue
end

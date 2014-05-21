json.code 200
json.body do |json|
  json.issue_deleted_count @issues_deleted_count
  json.image_deleted_count @images_deleted_count
end

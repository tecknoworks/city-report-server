json._id issue[:_id].to_s
json.(issue, :name, :status, :category, :device_id, :lat, :lon, :address, :neighborhood,
      :vote_counter, :images, :comments)
json.created_at issue.created_at
json.updated_at issue.updated_at

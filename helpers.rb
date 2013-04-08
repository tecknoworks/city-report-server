def do_render msg, code=200
  status code
  return {'code' => code, 'message' => msg}.to_json
end

def valid? params, verb=:post
  ['lat', 'lon', 'title'].each do |param|
    unless params[param]
      return do_render("#{param} param missing", 400)
    end
  end

  if params['title'].length > 141
    return do_render("title can not be longer than 141 chars", 400)
  end

  if verb == :put
    unless params['id']
      return do_render("id param missing", 400)
    end

    begin
      BSON::ObjectId(params['id'])
    rescue BSON::InvalidObjectId => e
      return do_render("invalid object format", 400)
    end
  end

  true
end

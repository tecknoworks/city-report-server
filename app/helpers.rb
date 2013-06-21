def db_wrap
  DbWrapper.new('thin.yml')
end

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

# TODO
# think of a better name
# this can also be resused for different keys like comment
# it is not consistent to return the image url - return the issue
def handle_issue_arrays key
  return do_render('id param missing', 400) unless params['id']
  return do_render("#{key} param missing", 400) unless params[key]

  # ensure issue exists
  # TODO extract this
  begin
    db_wrap.find_issue params['id']
  rescue
    return do_render('invalid image id', 400)
  end

  if key == 'image'
    image_url = db_wrap.save_image(params)['images'][0]
    db_wrap.add_to params['id'], 'images', image_url
    return { :url => image_url }.to_json
  else
    return do_render('please contact the developer, you shouldn\'t be here', 404)
  end
end

get '/' do
  haml :index
end

get '/doc' do
  markdown File.read('README.md')
end

get '/attributes' do
  content_type :json

  attributes = %w(id lat lon title description categories videos images comments created_at updated_at)
  categories = %w(altele groapa gunoi rutiere vandalism)
  {
    'attributes' => attributes,
    'categories' => categories
  }.to_json
end

get '/issues' do
  content_type :json
  db_wrap.issues.to_json
end

post '/issues' do
  content_type :json

  validation_error = valid? params
  return validation_error if validation_error.class != TrueClass

  db_wrap.save_image(params)
  db_wrap.create_issue(params).to_json
end

put '/issues' do
  content_type :json

  validation_error = valid?(params, :put)
  return validation_error if validation_error.class != TrueClass

  db_wrap.save_image(params)
  db_wrap.update_issue(params).to_json
end

post '/images' do
  content_type :json

  return do_render('image param missing', 400) unless params['image']

  image_url = db_wrap.save_image(params)['images'][0]
  { :url => image_url }.to_json
end

post '/add_to' do
  content_type :json

  return do_render('id missing', 400) unless params['id']
  return do_render('key missing', 400) unless params['key']
  return do_render('value missing', 400) unless params['value']

  db_wrap.add_to(params['id'], params['key'], params['value']).to_json
end

delete '/issues' do
  db_wrap.db['issues'].remove
end

db_wrap = DbWrapper.new('thin.yml')

get '/' do
  haml :index
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

get '/upload' do
  haml :upload
end

delete '/issues' do
  db_wrap.db['issues'].remove
end

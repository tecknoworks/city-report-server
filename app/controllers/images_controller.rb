class ImagesController < BaseController
  include ReparaHelper

  post '/' do
    tempfile = params[:image][:tempfile]
    filename = params[:image][:filename]
    storage_filename = serialize_filename filename
    storage_path = File.join('public/images/uploads', storage_filename)

    # todo manage logging to a file and add verbose copy
    # FileUtils::Verbose::cp
    FileUtils::cp(tempfile.path, storage_path)

    content_type :json
    {
      url: settings.config['base_url'] + 'images/uploads/' + storage_filename,
      thumb_url: settings.config['base_url'] + 'images/uploads/' + storage_filename
    }.to_json
  end
end

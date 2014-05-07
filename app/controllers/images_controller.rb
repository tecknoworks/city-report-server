class ImagesController < BaseController
  include ReparaHelper
  include ErrorCodes

  post '/' do
    tempfile = params[:image][:tempfile]
    filename = params[:image][:filename]
    unless image?(filename)
      return render_response('only png images allowed', INVALID_IMAGE_FORMAT, 400)
    end

    storage_filename = serialize_filename filename
    storage_path = File.join('public/images/uploads', storage_filename)
    thumb_path = File.join('public/images/uploads/thumbs/', storage_filename)

    # todo manage logging to a file and add verbose copy
    # FileUtils::Verbose::cp
    FileUtils::cp(tempfile.path, storage_path)
    FileUtils::cp('public/images/placeholder.png', thumb_path)

    ThumbnailWorker.perform_async(storage_path)

    render_response(generate_upload_response(storage_filename))
  end
end

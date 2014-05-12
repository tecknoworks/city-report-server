class ImagesController < BaseController
  include RequestCodes

  post '/' do
    if params[:image].nil?
      return render_response('missing image param', MISSING_IMAGE, BAD_REQUEST)
    end

    tempfile = params[:image][:tempfile]
    filename = params[:image][:filename]

    image = Image.create(original_filename: filename)
    unless image.valid?
      return render_response('only png images allowed', INVALID_IMAGE_FORMAT, BAD_REQUEST)
    end

    # todo manage logging to a file and add verbose copy
    # FileUtils::Verbose::cp
    FileUtils::cp(tempfile.path, image.storage_path)
    File.chmod(0755, image.storage_path)
    FileUtils::cp('public/images/placeholder.png', image.storage_thumb_path)

    ThumbnailWorker.perform_async(image.id.to_s)

    render_response(image.to_api)
  end

  delete '/' do
    return render_response("method not allowed", METHOD_NOT_ALLOWED) unless Repara.config['allow_delete_all']
    render_response(generate_delete_response(Image.delete_all))
  end
end

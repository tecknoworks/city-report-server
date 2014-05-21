class ImagesController < ApplicationController
  BAD_REQUEST = 400
  MISSING_IMAGE = 400005
  INVALID_IMAGE_FORMAT = 400101

  def render_response body, code=200, status_code=nil
    body = {
      code: code,
      body: body
    }
    status_code ||= code

    render json: body, status: status_code
  end

  def create
    if params['image'].nil?
      return render_response('missing image param', MISSING_IMAGE, BAD_REQUEST)
    end

    tempfile = params['image']
    filename = params['image'].original_filename

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
end

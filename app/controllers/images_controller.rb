class ImagesController < BaseController
  include ReparaHelper
  include RequestCodes

  post '/' do
    tempfile = params[:image][:tempfile]
    filename = params[:image][:filename]

    image = Image.new(original_filename: filename)
    unless image.valid?
      return render_response('only png images allowed', INVALID_IMAGE_FORMAT, 400)
    end
    image.save

    # todo manage logging to a file and add verbose copy
    # FileUtils::Verbose::cp
    FileUtils::cp(tempfile.path, image.storage_path)
    File.chmod(0755, image.storage_path)
    FileUtils::cp('public/images/placeholder.png', image.storage_thumb_path)

    ThumbnailWorker.perform_async(image.id.to_s)

    render_response(image.to_api)
  end
end

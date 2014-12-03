class ImagesController < ApplicationController

  resource_description do
    description <<-EOS
    EOS
  end

  api :POST, '/images', 'Upload an image'
  def create
    if params['image'].nil?
      return render_response('missing image param', MISSING_IMAGE, BAD_REQUEST)
    end

    tempfile = params['image']
    filename = params['image'].original_filename

    @image = Image.create(original_filename: filename)
    unless @image.valid?
      return render_response('only png images allowed', INVALID_IMAGE_FORMAT, BAD_REQUEST)
    end

    # todo manage logging to a file and add verbose copy
    # FileUtils::Verbose::cp
    FileUtils::cp(tempfile.path, @image.storage_path)
    File.chmod(0755, @image.storage_path)
    FileUtils::cp('public/images/placeholder.png', @image.storage_thumb_path)

    ThumbnailWorker.perform_async(@image.id.to_s)
  end
end

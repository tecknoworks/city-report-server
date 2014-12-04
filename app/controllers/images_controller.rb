class ImagesController < ApplicationController

  resource_description do
    description <<-EOS
    EOS
  end

  api :POST, '/images', 'Upload an image'
  param :image, Image, desc: 'the image', required: true
  description <<-EOS
    Only png images are supported. It will return a public url for the image
    and for the generated thumbnail.

    Sample HTML which would upload an image:

     <form action="/images" enctype="multipart/form-data" method="post">
       <input name="image" type="file">
       <input type="submit" value="Upload!">
     </form>

    Example with curl

     curl -X POST -F "image=@public/images/logo.png" #{URI.join(Repara.base_url, 'images')}
  EOS
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

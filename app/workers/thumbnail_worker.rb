class ThumbnailWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform image_id
    image = Image.find(image_id)

    if image.nil?
      logger.error "Image with id #{image_id} not found"
      return
    end

    logger.info "Resizing #{image.storage_path} -> #{image.storage_thumb_path}"

    img = MicroMagick::Image.new(image.storage_path)
    img.strip.quality(85).resize("100x100").write(image.storage_thumb_path)

    img = MicroMagick::Image.new(image.storage_path)
    img.strip.quality(85).resize("500x500").write(image.storage_path)
  end
end

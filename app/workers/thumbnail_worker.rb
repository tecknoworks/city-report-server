class ThumbnailWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform image_id
    image = Image.find(image_id)

    if image.nil?
      puts "image with id #{image_id} not found"
      return
    end

    puts "Resizing #{image.storage_path} -> #{image.storage_thumb_path}"

    img = MicroMagick::Image.new(image.storage_path)
    img.strip.quality(85).resize("256x256").write(image.storage_thumb_path)
  end
end

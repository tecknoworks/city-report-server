class ThumbnailWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform image_path, thumb_path
    puts "Resizing #{image_path} -> #{thumb_path}"

    img = MicroMagick::Image.new(image_path)
    img.strip.quality(85).resize("256x256").write(thumb_path)
  end
end

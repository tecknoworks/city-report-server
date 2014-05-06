class ThumbnailWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform image_path
    puts 'hello world'
    # do stuff here
  end
end

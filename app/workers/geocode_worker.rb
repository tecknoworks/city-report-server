class GeocodeWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform issue_id
    # do stuff here
  end
end

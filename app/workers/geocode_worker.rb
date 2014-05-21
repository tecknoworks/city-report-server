class GeocodeWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform issue_id
    issue = Issue.find(issue_id)

    if issue.nil?
      logger.error "Issue with id #{issue_id} not found"
      return
    end

    address = Geocoder.kung_foo issue[:lat], issue[:lon]
    logger.info "GEOCODED #{issue[:lat]} and #{issue[:lon]} to #{address}"

    issue[:address] = address
    issue.save
  end
end

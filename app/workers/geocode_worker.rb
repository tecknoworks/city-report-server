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

    json = Geocoder.get_info_zone issue[:lat], issue[:lon]

    address = json['results'][0]['formatted_address']
    logger.info "GEOCODED #{issue[:lat]} and #{issue[:lon]} to #{address}"

    neighborhood = json['results'][1]['address_components'][0]["long_name"]
    logger.info "GEOCODED #{issue[:lat]} and #{issue[:lon]} to #{neighborhood}"

    issue[:address] = address
    issue[:neighborhood] = neighborhood
    issue.index_keywords!
    issue.save

    SendmailWorker.perform_async(issue_id)
  end
end

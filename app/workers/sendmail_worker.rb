class SendmailWorker
  include Sidekiq::Worker
  sidekiq_options quque: "high"
  # sidekiq_options retry: false

  def perform issue_id
    issue = Issue.find(issue_id)

    if issue.nil?
      logger.error "Issue with id #{issue_id} not found"
      return
    end

    category = Category.where(name: issue.category).first
    category_admin = CategoryAdmin.where(categories: category)

    emails = []

    category_admin.each do |ca|
      emails.push(ca.admin_user.email)
    end

    emails.each do |email|
      SendgridToolkit::Mail.new(ENV['USERNAME'], ENV['API_KEY']).send_mail(
      :to => email,
      :from => "city-report-cluj",
      :subject => "S-a creat un nou issue",
      :text => "A fost creat un nou issue la data de #{issue.created_at} \

      Date despre issue:
      titlu: #{issue.name}
      categorie: #{issue.category}
      adresa: #{issue.address}
      "
      )
    end
  end
end

class IssuesController < BaseController
  get '/' do
    json Issue.all
  end

  post '/' do
    issue = Issue.new(params)
    issue.save
    if issue.valid?
      json issue
    else
      json issue.errors
    end
  end
end

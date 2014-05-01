class IssuesController < BaseController
  get '/' do
    'issues'
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

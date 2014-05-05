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
      status 400
      json issue.errors
    end
  end

  put '/:id' do
    # there params come from mongoid. don't want them
    params.delete('splat')
    params.delete('captures')

    # TODO check for invalid id
    issue = Issue.find(params[:id])
    issue.update_attributes(params)
    if issue.valid?
      json issue
    else
      status 400
      json issue.errors
    end
  end

  put '/:id/add_to_set' do
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    # TODO test for issue not found
    params['images'].each do |s|
      issue.add_to_set(:images, s)
    end
    issue.save

    if issue.valid?
      json issue
    else
      status 400
      json issue.errors
    end
  end
end

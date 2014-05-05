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
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    return generate_error(404, "issue with id #{params[:id]} not found") if issue.nil?

    issue.update_attributes(params)

    if issue.valid?
      json issue
    else
      generate_error(400, 'invalid params', issue.errors)
    end
  end

  put '/:id/add_to_set' do
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    return generate_error(404, "issue with id #{params[:id]} not found") if issue.nil?

    params['images'].each do |s|
      issue.add_to_set('images', s)
    end

    if issue.valid?
      json issue
    else
      generate_error(400, 'invalid params', issue.errors)
    end
  end
end

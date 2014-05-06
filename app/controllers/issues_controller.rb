class IssuesController < BaseController
  get '/' do
    limit = params['limit'].nil? ? 10 : params['limit']
    skip = params['skip'].nil? ? 0 : params['skip']

    issues = Issue.order_by([:created_at, :desc]).limit(limit).skip(skip)
    render_response issues
  end

  def get_error_code issue
    key = issue.errors.first.first
    case key
    when :name
      code = 400001
    when :lat, :lon
      code = 400002
    when :category
      code = 400003
    when :images
      code = 400004
    else
      code = 400000
    end
    code
  end

  post '/' do
    issue = Issue.new(params)
    if issue.valid?
      issue.save
      render_response issue
    else
      render_response('invalid params', get_error_code(issue), 400)
    end
  end

  put '/:id' do
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", 404) if issue.nil?

    issue.update_attributes(params)

    if issue.valid?
      render_response issue
    else
      render_response('invalid params', get_error_code(issue), 400)
    end
  end

  put '/:id/add_to_set' do
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", 404) if issue.nil?

    params['images'].each do |s|
      issue.add_to_set('images', s)
    end

    if issue.valid?
      render_response issue
    else
      render_response('invalid params', get_error_code(issue), 400)
    end
  end
end

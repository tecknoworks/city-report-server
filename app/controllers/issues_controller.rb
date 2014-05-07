class IssuesController < BaseController
  include ErrorCodes

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
      code = MISSING_NAME
    when :lat, :lon
      code = INVALID_COORDINATES
    when :category
      code = INVALID_CATEGORY
    when :images
      code = REQUIRES_AT_LEAST_ONE_IMAGE
    else
      code = UNKNOWN_ERROR
    end
    code
  end

  post '/' do
    issue = Issue.new(params)
    if issue.valid?
      issue.save

      GeocodeWorker.perform_async issue[:_id].to_s

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

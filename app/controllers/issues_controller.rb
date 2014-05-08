class IssuesController < BaseController
  include RequestCodes

  get '/' do
    limit = params['limit'].nil? ? 10 : params['limit']
    skip = params['skip'].nil? ? 0 : params['skip']

    issues = Issue.order_by([:created_at, :desc]).limit(limit).skip(skip)
    render_response issues
  end

  post '/' do
    issue = Issue.new(params)
    if issue.valid?
      issue.save

      GeocodeWorker.perform_async issue[:_id].to_s

      render_response issue
    else
      render_response('invalid params', get_error_code(issue), BAD_REQUEST)
    end
  end

  put '/:id' do
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", NOT_FOUND) if issue.nil?

    issue.update_attributes(params)

    if issue.valid?
      render_response issue
    else
      render_response('invalid params', get_error_code(issue), BAD_REQUEST)
    end
  end

  put '/:id/add_to_set' do
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", NOT_FOUND) if issue.nil?

    params['images'].each do |s|
      issue.add_to_set('images', s)
    end

    if issue.valid?
      render_response issue
    else
      render_response('invalid params', get_error_code(issue), BAD_REQUEST)
    end
  end

  delete '/' do
    return render_response("method not allowed", 405) unless Repara.config['allow_delete_all_issues']
    render_response(generate_delete_response(Issue.delete_all))
  end

  def get_error_code issue
    key = issue.errors.first.first
    case key
    when :name
      code = MISSING_NAME
    when :invalid_lat, :invalid_lon
      code = INVALID_COORDINATES
    when :invalid_category
      code = INVALID_CATEGORY
    when :invalid_image_url
      code = INVALID_IMAGE_URL
    when :invalid_image_format
      code = INVALID_IMAGE_FORMAT
    when :minimum_one_image_required
      code = REQUIRES_AT_LEAST_ONE_IMAGE
    else
      code = UNKNOWN_ERROR
    end
    code
  end

end

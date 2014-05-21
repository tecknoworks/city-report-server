class IssuesController < ApplicationController
  include RequestCodes

  def issues_search_results
    limit = params['limit'].nil? ? 10 : params['limit']
    skip = params['skip'].nil? ? 0 : params['skip']
    query = params['q']

    Issue.order_by([:created_at, :desc]).limit(limit).skip(skip).full_text_search(query)
  end

  def index
    @issues = issues_search_results
  end

  def show
    @issue = Issue.find(params[:id])

    if @issue.nil?
      return render_response("issue with id #{params[:id]} not found", NOT_FOUND)
    end
  end

  def create
    # do not allow the vote_counter to be different than 0
    params.delete('vote_counter')

    @issue = Issue.create(params)

    unless @issue.valid?
      return render_response(error_desc_for(@issue), error_code_for(@issue), BAD_REQUEST)
    end

    @issue.index_keywords!

    GeocodeWorker.perform_async @issue[:_id].to_s
  end

  def update
    # do not allow the update of the vote_counter
    params.delete('vote_counter')

    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    @issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", NOT_FOUND) if @issue.nil?

    @issue.update_attributes(params)

    unless @issue.valid?
      return render_response(error_desc_for(@issue), error_code_for(@issue), BAD_REQUEST)
    end

    @issue.index_keywords!
  end

  def add_to_set
    # there params come from mongoid. we don't want them
    params.delete('splat')
    params.delete('captures')

    @issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", NOT_FOUND) if @issue.nil?

    @issue.add_params_to_set(params)

    unless @issue.valid?
      return render_response(error_desc_for(@issue), error_code_for(@issue), BAD_REQUEST)
    end

    @issue.index_keywords!
  end

  def vote
    @issue = Issue.find(params[:id])
    return render_response("issue with id #{params[:id]} not found", NOT_FOUND) if @issue.nil?

    @issue.upvote! if request.post?
    @issue.downvote! if request.delete? && Repara.config['allow_downvotes']
  end

  # TODO move this in the correct place
  def error_desc_for issue
    issue.errors.first.join(' ')
  end

  def error_code_for model
    case model.errors.first.first
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
    when :invalid_image_hash_format
      code = INVALID_IMAGE_HASH_FORMAT
    when :invalid_comment_format
      code = INVALID_COMMENT_FORMAT
    when :string_too_big
      code = STRING_TOO_BIG
    else
      code = UNKNOWN_ERROR
    end
    code
  end
end

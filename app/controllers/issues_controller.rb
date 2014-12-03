class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :add_to_set, :update, :vote]
  before_action :no_vote_cheating, only: [:update, :create]

  api :GET, '/issues'
  def index
    limit = params['limit'].nil? ? 10 : params['limit']
    skip = params['skip'].nil? ? 0 : params['skip']
    query = params['q']

    @issues = Issue.order_by([:created_at, :desc]).limit(limit).skip(skip).full_text_search(query)
  end

  def show
  end

  def create
    @issue = Issue.create(params)

    unless @issue.valid?
      return render_response(@issue.first_error_desc, @issue.first_error_code, BAD_REQUEST)
    end

    @issue.index_keywords!

    GeocodeWorker.perform_async @issue[:_id].to_s
  end

  def update
    @issue.update_attributes(params)

    unless @issue.valid?
      return render_response(@issue.first_error_desc, @issue.first_error_code, BAD_REQUEST)
    end

    @issue.index_keywords!
  end

  def add_to_set
    @issue.add_params_to_set(params)

    unless @issue.valid?
      return render_response(@issue.first_error_desc, @issue.first_error_code, BAD_REQUEST)
    end

    @issue.index_keywords!
  end

  def vote
    @issue.upvote! if request.post?
    @issue.downvote! if request.delete? && Repara.config['allow_downvotes']
  end

  private

  def no_vote_cheating
    params.delete('vote_counter')
  end

  def set_issue
    @issue = Issue.find(params[:id])
    if @issue.nil?
      render_response("issue with id #{params[:id]} not found", NOT_FOUND)
    end
  end
end

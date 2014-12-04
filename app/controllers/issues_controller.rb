class IssuesController < ApplicationController

  resource_description do
    description <<-EOS
      ==== Info

      All requests should have the Content-Type header set to <b>application/json</b>

      If no address is specified, the address will be geocoded from lat and lon

      issue.category will be lower cased by the server

      ==== Max string length

      * name #{Repara.name_max_length}
      * comment #{Repara.comments_max_length}
      * address #{Repara.address_max_length}

      ==== Example issue

       {
         name: 'issue name',
         category: 'altele'
         lat: 0,
         lon: 0,
         address: '',
         images: [
           {
             url: 'url_to_image.png',
             thumb_url: 'url_to_thumb.png'
           },
           {
             url: 'url_to_image.png',
             thumb_url: 'url_to_thumb.png'
           }
         ],
         comments: [
           'comment1',
           'comment2'
         ]

       }
    EOS
  end

  before_action :set_issue, only: [:show, :add_to_set, :update, :vote]
  before_action :no_vote_cheating, only: [:update, :create]

  api :GET, '/issues.json', 'Return issue list'
  param :q, String, desc: 'search query string'
  param :limit, :number, desc: 'limit items per page, default 10'
  param :skip, :number, desc: 'skip items, default 0'
  description <<-EOS
    curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}issues.json
  EOS
  def index
    limit = params['limit'].nil? ? 10 : params['limit']
    skip = params['skip'].nil? ? 0 : params['skip']
    query = params['q']

    @issues = Issue.order_by([:created_at, :desc]).limit(limit).skip(skip).full_text_search(query)
  end

  api :GET, '/issues/:id.json', 'Return a specific issue'
  description <<-EOS
    curl -X GET -H 'Content-Type: application/json' #{Repara.base_url}issues/ISSUE_ID.json
  EOS
  def show
  end

  api :POST, '/issues.json', 'Create an issue'
  description <<-EOS
    Required body params: name, device_id, category, lat, lon, images

    curl -X POST -H 'Content-Type: application/json' -d '{"name":"hello", "device_id": "device_id", "category":"altele", "lat":0, "lon":0,"images":[{"url": "image_url"}]}' #{Repara.base_url}issues.json
  EOS
  def create
    @issue = Issue.create(params)

    unless @issue.valid?
      return render_response(@issue.first_error_desc, @issue.first_error_code, BAD_REQUEST)
    end

    @issue.index_keywords!

    GeocodeWorker.perform_async @issue[:_id].to_s
  end

  api :PATCH, '/issues/:id.json', 'Update an issue'
  description <<-EOS
  EOS
  def update
    @issue.update_attributes(params)

    unless @issue.valid?
      return render_response(@issue.first_error_desc, @issue.first_error_code, BAD_REQUEST)
    end

    @issue.index_keywords!
  end

  api :PATCH, '/issues/:id/add_to_set.json', 'Add items to the set'
  description <<-EOS
    Valid sets: 'images', 'comments'
  EOS
  def add_to_set
    @issue.add_params_to_set(params)

    unless @issue.valid?
      return render_response(@issue.first_error_desc, @issue.first_error_code, BAD_REQUEST)
    end

    @issue.index_keywords!
  end

  api :POST, '/issues/:id/vote.json', 'Vote on an issue'
  description <<-EOS
    When making a POST request, the length is mandatory. Send an empty hash if needed
  EOS
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

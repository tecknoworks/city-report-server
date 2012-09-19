class IssuesController < ApplicationController
  api :GET, "/issues", "Show all issues"
  description "returns a JSON containing all the issues available"
  formats ['json']
  example "{
    'status':{
      'code':200,
      'message':'Success'
    },
    'response': {
      'issues':[
        {issue1},
        {issue2},
        ...
        ]
    }
}"
  def index
    issues = Issue.all
    respond_to do |format|
      format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issues:issues}) }
    end
  end

  api :POST, "/issues", "Create one issue"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  param :title, String, :desc => "Title of the new issue", :required => true
  param :latitude, Float, :desc => "latitude of the new issue", :required => true
  param :longitude, Float, :desc => "longitude of the new issue", :required => true
  param :category_id, Fixnum, :desc => "Issue's category id", :required => true
  description "Creates a issue on succes; return JSON with status code succes or bad request. Also, returns the created issue on success."
  formats ['json']
  example "{
    'status':{
      'code':200,
      'message':'Success'
    },
    'response': {
      'issue': {
          'id': 132,
          'title': 'Groapa in fata teatrului din Cluj',
          'latitude': 2.3232,
          'longitude': 21.3232,
          'category_id': 123,
          'updated_at': '2012-09-13 15:14:33',
          'created_at': '2012-09-13 15:06:33'
        }
    }
}"
  example "{
    'status':{
      'code': 400,
      'message':'Bad Request'
    },
    'response': {
    }
}"
  def create
    if !params[:issue].nil? && issue_params_valid?(params[:issue])
      @issue = Issue.create(params[:issue])
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issue:@issue}) }
      end
    else
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.BAD_REQUEST_CODE, ApiStatus.BAD_REQUEST, nil) }
      end
    end
  end

  def issue_params_valid? issue
    return false if issue[:title].nil?
    return false if issue[:latitude].nil?
    return false if issue[:longitude].nil?
    return false if issue[:category_id].nil?
    return false if Category.find(issue[:category_id]).nil?
    return true
  end
end

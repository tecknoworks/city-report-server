class IssuesController < ApplicationController
  respond_to :json

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
    respond_with render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issues:issues})
  end

  api :POST, "/issues", "Create one issue"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  param :title, String, :desc => "Title of the new issue; must be under issue node/hash", :required => true
  param :latitude, Float, :desc => "latitude of the new issue; must be under issue node/hash", :required => true
  param :longitude, Float, :desc => "longitude of the new issue; must be under issue node/hash", :required => true
  param :category_id, Fixnum, :desc => "Issue's category id; must be under issue node/hash", :required => true
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

  api :PUT, "/issue/:id", "Edit one issue"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  error :code => ApiStatus.NOT_FOUND_CODE, :desc => ApiStatus.NOT_FOUND
  param :title, String, :desc => "new title; must be under issue node/hash", :required => false
  param :latitude, Float, :desc => "new latitude; must be under issue node/hash", :required => false
  param :longitude, Float, :desc => "new longitude; must be under issue node/hash", :required => false
  param :category_id, Fixnum, :desc => "new category_id; must be under issue node/hash", :required => false
  description "Edits a issue on succes; return JSON with status code succes or bad request."
  formats ['json']
  example "{ 
    'status':{
      'code':200,
      'message':'Success'
    }, 
    'response': {
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
  example "{ 
    'status':{
      'code':404,
      'message':'Not Found'
    }, 
    'response': {
    }
}"
  def update
    if Issue.exists?(params[:id])
      if !params[:issue].nil? && issue_can_be_updated?(params[:issue])
        issue = Issue.find(params[:id])
        issue.update_attributes(params[:issue])
        issue.save
        respond_to do |format|
          format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, nil) }
        end
      else
        respond_to do |format|
          format.json { render :json => render_response(ApiStatus.BAD_REQUEST_CODE, ApiStatus.BAD_REQUEST, nil) }
        end
      end
    else
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.NOT_FOUND_CODE, ApiStatus.NOT_FOUND, nil) }
      end
    end
  end


  api :DELETE, "/issue/:id", "Delete one issue"
  error :code => ApiStatus.NOT_FOUND_CODE, :desc => ApiStatus.NOT_FOUND
  description "Deletes a issue on succes; return JSON with status code succes or bad request."
  formats ['json']
  example "{ 
    'status':{
      'code':200,
      'message':'Success'
    }, 
    'response': {
    }
}"
  example "{ 
    'status':{
      'code': 404,
      'message':'Not Found'
    }, 
    'response': {
    }
}"
  def destroy
    if Issue.exists?(params[:id])
      Issue.delete(params[:id])
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, nil) }
      end
    else
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.NOT_FOUND_CODE, ApiStatus.NOT_FOUND, nil) }
      end
    end
  end


  private
  def issue_params_valid? issue
    return false if issue[:title].nil?
    return false if issue[:latitude].nil?
    return false if issue[:longitude].nil?
    return false if issue[:category_id].nil?
    return false if Category.find(issue[:category_id]).nil?
    return true
  end

  def issue_can_be_updated? issue
    return true unless issue[:title].nil?
    return true unless issue[:latitude].nil?
    return true unless issue[:longitude].nil?
    if issue[:category_id].present?
      return true unless Category.find(issue[:category_id]).nil?
    end
    return false
  end
end

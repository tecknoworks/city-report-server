class ApiController < ApplicationController
  api :POST, "/api/issues", "Create one issue with category on the fly"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  param :title, String, :desc => "Title of the new issue; must be under issue node/hash", :required => true
  param :latitude, Float, :desc => "latitude of the new issue; must be under issue node/hash", :required => true
  param :longitude, Float, :desc => "longitude of the new issue", :required => true
  param :category_name, String, :desc => "Issue's category name. WARNING! this parameter must be separate from the issue hash", :required => true
  description "Creates a issue plus a category on succes; return JSON with status code succes or bad request. Also, returns the created issue on success."
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
  def create_issue_auto_category
    if !params[:issue].nil? && issue_params_valid?(params[:issue]) && !params[:category_name].nil?
      @category = Category.create(:name => params[:category_name])
      issue = params[:issue]
      issue[:category_id] = @category.id
      @issue = Issue.create(issue)
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issue:@issue}) }
      end
    else
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.BAD_REQUEST_CODE, ApiStatus.BAD_REQUEST, nil) }
      end
    end
  end


  api :PUT, "api/issue/:id", "Edit one issue with creating category on the fly"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  error :code => ApiStatus.NOT_FOUND_CODE, :desc => ApiStatus.NOT_FOUND
  param :title, String, :desc => "new title; must be under issue node/hash", :required => false
  param :latitude, Float, :desc => "new latitude; must be under issue node/hash", :required => false
  param :longitude, Float, :desc => "new longitude; must be under issue node/hash", :required => false
  param :category_name, Fixnum, :desc => "new category name to be created on the fly; must not be under the issue hash(node)", :required => false
  description "Edits a issue on succes plus creating a category if needed; return JSON with status code succes or bad request."
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
  def edit_issue_auto_category
    if Issue.exists?(params[:id])
      if issue_can_be_updated?(params[:issue]) || params[:category_name].present?
        issue = Issue.find(params[:id])
        if issue_can_be_updated?(params[:issue])
          issue.update_attributes(params[:issue])
        end
        if params[:category_name].present?
          category = Category.create(:name => params[:category_name])
          issue.category_id = category.id
        end
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

  def issues_within_region
    issues = Issue.in_area(params[:upleft_latitude], params[:downright_latitude], params[:upleft_longitude], params[:downright_longitude]);
    respond_to do |format|
      format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {issues:issues}) }
    end
  end

  private
  def issue_params_valid? issue
    return false if issue[:title].nil?
    return false if issue[:latitude].nil?
    return false if issue[:longitude].nil?
    return true
  end

  def issue_can_be_updated? issue
    return false if issue.nil?
    return true unless issue[:title].nil?
    return true unless issue[:latitude].nil?
    return true unless issue[:longitude].nil?
    return false
  end
end

class ApiController < ApplicationController
  api :POST, "/api/issues", "Create one issue with category on the fly"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  param :title, String, :desc => "Title of the new issue", :required => true
  param :latitude, Float, :desc => "latitude of the new issue", :required => true
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

  private
  def issue_params_valid? issue
    return false if issue[:title].nil?
    return false if issue[:latitude].nil?
    return false if issue[:longitude].nil?
    return true
  end
end

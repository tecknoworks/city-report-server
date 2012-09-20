class CategoriesController < ApplicationController
  api :GET, "/categories", "Show all categories"
  description "returns a JSON containing all the categories available"
  formats ['json']
  example "{ 
    'status':{
      'code':200,
      'message':'Success'
    }, 
    'response': {
      'categories':[
        {cat1},
        {cat2},
        ...
        ]
    }
}"
  def index
    categories = Category.all
    respond_to do |format|
      format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {categories:categories}) }
    end
  end

  api :POST, "/categories", "Create one category"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  param :name, String, :desc => "Name of the new category", :required => true
  description "Creates a category on succes; return JSON with status code succes or bad request. Also, returns the created category on success."
  formats ['json']
  example "{ 
    'status':{
      'code':200,
      'message':'Success'
    }, 
    'response': {
      'category': {
          'id': 132,
          'name': 'groapa',
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
    if !params[:category].nil? && !params[:category][:name].nil?
      @category = Category.new(params[:category])
      @category.save
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {category:@category}) }
      end
    else
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.BAD_REQUEST_CODE, ApiStatus.BAD_REQUEST, nil) }
      end
    end
  end

  api :PUT, "/category/:id", "Edit one category"
  error :code => ApiStatus.BAD_REQUEST_CODE, :desc => ApiStatus.BAD_REQUEST
  error :code => ApiStatus.NOT_FOUND_CODE, :desc => ApiStatus.NOT_FOUND
  param :name, String, :desc => "new name", :required => true
  description "Edits a category on succes; return JSON with status code succes or bad request."
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
    if Category.exists?(params[:id])
      if !params[:category].nil? && !params[:category][:name].nil?
        category = Category.find(params[:id])
        category.update_attributes(params[:category])
        category.save
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

  api :DELETE, "/category/:id", "Delete one category"
  error :code => ApiStatus.NOT_FOUND_CODE, :desc => ApiStatus.NOT_FOUND
  description "Deletes a category on succes; return JSON with status code succes or bad request."
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
    if Category.exists?(params[:id])
      Category.delete(params[:id])
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, nil) }
      end
    else
      respond_to do |format|
        format.json { render :json => render_response(ApiStatus.NOT_FOUND_CODE, ApiStatus.NOT_FOUND, nil) }
      end
    end
  end
end

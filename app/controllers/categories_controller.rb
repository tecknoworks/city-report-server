class CategoriesController < ApplicationController
  def render_response a, b, c
    "foo"
  end
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
  see "categories#index"
  def index
    categories = Category.all
    respond_to do |format|
      format.json { render :json => render_response(ApiStatus.OK_CODE, ApiStatus.OK, {categories:categories}) }
    end
  end

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

class CategoriesController < ApplicationController
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

class CategoriesController < ApplicationController
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
end

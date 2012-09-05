class CategoriesController < ApplicationController
  def create
    if !params[:category].nil? && !params[:category][:name].nil?
      @category = Category.new(params[:category])
      @category.save
      respond_to do |format|
        format.json { render :json => @category }
      end
    else
      respond_to do |format|
        error = {:error => {:code => "1"} }
        format.json { render :json => error }
      end
    end
  end
end

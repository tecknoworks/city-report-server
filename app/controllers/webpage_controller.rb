class WebpageController < ApplicationController
  def index
    @categories = Category.all
    @issues = Issue.all
  end

  def show
    @categories = Category.all
    @issues = Issue.where(:category_id => params[:id])

    render :action => 'index'
  end

end

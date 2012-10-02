class WebpageController < ApplicationController
  def index
    @categories = Category.all
    @issues = Issue.all
  end

  def about
  end

  def contact
  end
end

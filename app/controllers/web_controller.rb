class WebController < ApplicationController

  def meta
    render json: Repara.config['meta']
  end

  def doc
  end

  def up
  end

  def about
  end

  def eula
  end
end

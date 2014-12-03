class WebController < ApplicationController

  before_action :check_for_lang, only: [:about, :eula]
  before_action :check_for_no_layout, only: [:about, :eula]

  def index
  end

  def meta
    render json: Repara.config['meta']
  end

  def up
    render_404 and return unless Repara.show_doc?
  end

  def about
  end

  def eula
  end

  def cleanup
    return render_response("method not allowed", METHOD_NOT_ALLOWED) unless Repara.config['allow_delete_all']

    @issues_deleted_count = Issue.delete_all
    @images_deleted_count = Image.delete_all
  end

  protected

  def check_for_lang
    default_lang = Repara.default_eula_language
    @lang = params[:lang].present? ? params[:lang] : default_lang
    @lang = default_lang unless Repara.valid_eula_languages.include? @lang
  end

  def check_for_no_layout
    render :layout => !params[:no_layout].present?
  end
end

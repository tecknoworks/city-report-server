class WebController < ApplicationController

  before_action :check_for_lang, only: [:about, :eula]
  before_action :check_for_no_layout, only: [:about, :eula]

  def index
  end

  def meta
  end

  def doc
    render_404 and return unless Repara.show_doc?

    @issues_deleted_count = 42
    @images_deleted_count = 7

    @issue = Issue.new(name: 'name', address: '', lat: Repara.map_center['lat'], lon: Repara.map_center['lon'], created_at: Time.now, updated_at: Time.now, category: Repara.categories.last, images: [{url: "#{Repara.base_url}images/logo.png", thumb_url: "#{Repara.base_url}images/thumb.png"}], comments: ['nice'] )

    @image = Image.new(original_filename: 'filename.png')
    # Hack to call a protected method. Only want it for documentation purposes
    @image.send(:set_data_from_original_filename)

    # checking for this in the /doc request
    raise 'issue example in documentation out of date' unless @issue.valid?
    # render_to_string( template: 'web/cleanup.jbuilder', locals: { issues_deleted_count: 42, images_deleted_count: 7})
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

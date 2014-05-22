class WebController < ApplicationController

  def index
  end

  def meta
    render json: Repara.config['meta']
  end

  def doc
    @issues_deleted_count = 42
    @images_deleted_count = 7

    @issue = Issue.new(name: 'name', address: '', lat: 0, lon: 0, created_at: Time.now, updated_at: Time.now, category: Repara.categories.last, images: [{url: "#{Repara.base_url}images/logo.png", thumb_url: "#{Repara.base_url}images/thumb.png"}], comments: ['nice'] )

    @image = Image.new(original_filename: 'filename.png')
    # Hack to call a protected method. Only want it for documentation purposes
    @image.send(:set_data_from_original_filename)

    # checking for this in the /doc request
    raise 'issue example in documentation out of date' unless @issue.valid?
    # render_to_string( template: 'web/cleanup.jbuilder', locals: { issues_deleted_count: 42, images_deleted_count: 7})
  end

  def up
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
end

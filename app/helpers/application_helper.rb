module ApplicationHelper
  # Hacks over hacks over hacks
  # this method is used to render jbuilder templates
  def preview_jbuilder path
    jbuilder_path = File.join(Rails.root, 'app/views', path)
    jbuilder_path += '.jbuilder' unless jbuilder_path.end_with? '.jbuilder'

    jb = File.read(jbuilder_path)
    if path == 'issues/_issue'
      jb.gsub!('issue', '@issue')
    end

    s = Jbuilder.encode do |json|
      eval jb
    end
    pretty_json s
  end

  def render_response_without_changing_status body, code=200
    {
      code: code,
      body: body
    }
  end

  def pretty_json h
    JSON.pretty_generate(JSON.parse(h))
  end

  def doc_issue
    issue = Issue.new(name: 'name', address: '', lat: 0, lon: 0, created_at: Time.now, updated_at: Time.now, category: Repara.categories.last, images: [{url: "#{Repara.base_url}images/logo.png", thumb_url: "#{Repara.base_url}/images/thumb.png"}], comments: ['nice'] )
    # checking for this in the /doc request
    raise 'issue example in documentation out of date' unless issue.valid?
    issue
  end

  def doc_image
    image = Image.new(original_filename: 'foo.png')
    # Hack to call a protected method.
    # Only want it for documentation purposes
    image.send(:set_data_from_original_filename)
    image.to_api
  end

  def generate_delete_response items_deleted
    {
      deleted_objects_count: items_deleted
    }
  end

end

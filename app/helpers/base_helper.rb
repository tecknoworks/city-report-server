module BaseHelper
  def base_url
    settings.config['base_url']
  end

  def doc_issue
    Issue.new(name: 'name', address: '', lat: 0, lon: 0, created_at: Time.now, updated_at: Time.now, category: Repara.categories.last, images: ["#{base_url}images/logo.png"])
  end

  def pretty_json h
    JSON.pretty_generate(JSON.parse(h))
  end

  def generate_upload_response storage_filename
    {
      url: base_url + 'images/uploads/original/' + storage_filename,
      thumbUrl: base_url + 'images/uploads/thumbs/' + storage_filename
    }
  end

  def generate_delete_response items_deleted
    {
      deletedIssuesCount: items_deleted
    }
  end

  def render_response body, code=200, status_code=nil
    status_code ||= code
    status status_code
    json(render_response_without_changing_status(body, code))
  end

  def render_response_without_changing_status body, code=200
    {
      code: code,
      body: body
    }
  end
end

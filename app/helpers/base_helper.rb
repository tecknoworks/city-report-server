# Helper for BaseController
# this module is included in the sinatra helpers
module BaseHelper
  def base_url
    Repara.config['base_url']
  end

  def doc_issue
    issue = Issue.new(name: 'name', address: '', lat: 0, lon: 0, created_at: Time.now, updated_at: Time.now, category: Repara.categories.last, images: [{url: "#{base_url}images/logo.png"}])
    # checking for this in the /doc request
    raise 'shame on the developer' unless issue.valid?
    issue
  end

  def doc_image
    image = Image.new(original_filename: 'foo.png')
    # Hack to call a protected method.
    # Only want it for documentation purposes
    image.send(:set_data_from_original_filename)
    render_response_without_changing_status(image.to_api).to_json
  end

  def pretty_json h
    JSON.pretty_generate(JSON.parse(h))
  end

  def generate_delete_response items_deleted
    {
      deletedObjectsCount: items_deleted
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

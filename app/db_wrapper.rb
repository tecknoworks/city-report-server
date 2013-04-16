class DbWrapper
  attr_reader :db, :config

  def initialize config_file
    @config = DbWrapper.read_config config_file

    client = Mongo::MongoClient.new(@config['db_host'], @config['db_port'])
    @db = client[@config['db_name']]
  end

  def issues
    @db['issues'].find.to_api
  end

  def find_issue id
    @db['issues'].find({'_id' => BSON::ObjectId(id.to_s)}).to_api.first
  end

  def create_issue params
    delete_unwanted_params params
    id = @db['issues'].insert(params)
    find_issue id
  end

  def update_issue params, keep_history=false
    id = params['id']
    delete_unwanted_params params

    # keeping track of history
    if keep_history
      history = find_issue id
      history.delete('id')
      old_issue = history.clone
      old_issue.delete('history')
      if old_issue != params
        params['history'] = history
      end
    end

    @db['issues'].update({'_id' => BSON::ObjectId(id.to_s)}, params)
    find_issue id
  end

  def save_image params
    if params['image']
      tempfile = params['image'][:tempfile]
      fp = image_path
      FileUtils.copy_file(tempfile.path, fp)

      unless params.has_key? 'images'
        params['images'] = []
      end

      params['images'] << image_url_path(fp)
    end
    params
  end

  def image_url_path img_path
    '/' + img_path.split('/').delete_if{|e| e == 'public' || e == 'spec'}.join('/')
  end

  def image_path
    iup = config['image_upload_path']
    count = Dir[File.join(iup, '*')].count.to_s
    File.join(iup, count + '.png')
  end

  private

  def delete_unwanted_params params
    params.delete('id')
    params.delete('image')
    params.delete(:image)
  end

  def self.read_config config_file
    YAML.load_file config_file
  end
end
